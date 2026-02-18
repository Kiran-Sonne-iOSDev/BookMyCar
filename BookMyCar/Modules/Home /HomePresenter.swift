//
//  HomePresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import Foundation
import Combine
import MapKit
import CoreLocation
import SwiftData

// MARK: - Home Presenter Protocol
protocol HomePresenterProtocol: ObservableObject {
    var mapRegion: MKCoordinateRegion { get set }
    var nearbyCars: [TaxiCarEntity] { get }
    var selectedRoute: RouteEntity? { get }
    var carTypes: [CarTypeEntity] { get }
    var selectedCarType: CarTypeEntity? { get }
    var estimatedDistance: String { get }
    var estimatedTime: String { get }
    var estimatedPrice: String { get }
    func loadNearbyCars()
    func selectCarType(_ carType: CarTypeEntity)
    func bookRide()
}

 class HomePresenter: HomePresenterProtocol {
     var modelContext: ModelContext?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var nearbyCars: [TaxiCarEntity] = []
    @Published var selectedRoute: RouteEntity?
    @Published var selectedCarType: CarTypeEntity?
    @Published var rideEstimate: RideEstimateEntity?
    @Published var pickupLocation: LocationEntity?
    @Published var destinationLocation: LocationEntity?
    
    @Published var pickupQuery = ""
    @Published var destinationQuery = ""
    @Published var pickupSuggestions: [MKMapItem] = []
    @Published var destinationSuggestions: [MKMapItem] = []
    @Published var navigateToConfirmation: RideBookingModel?
    @Published var showPaymentSelection = false
    @Published var pendingBooking: RideBookingModel?


    // MARK: - Computed Properties
    var carTypes: [CarTypeEntity] {
        CarTypeEntity.all
    }
    
    var estimatedDistance: String {
        rideEstimate?.distanceText ?? "--"
    }
    
    var estimatedTime: String {
        rideEstimate?.durationText ?? "--"
    }
    
    var estimatedPrice: String {
        rideEstimate?.priceText ?? "--"
    }
    
    // MARK: - Dependencies
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    private let locationSearchService: LocationSearchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol, locationSearchService: LocationSearchServiceProtocol) {
        self.locationSearchService = locationSearchService
        self.interactor = interactor
        self.router = router
        
        // Set default car type
        selectedCarType = CarTypeEntity.mini
        
        bindSearch()
        observeLocationChanges()
    }
    
      func completeBookingWithoutCard(booking: RideBookingModel) {
         // The booking is already saved in PaymentSelectionView
         // Just navigate to confirmation
         navigateToConfirmation = booking
         pendingBooking = nil
         showPaymentSelection = false
     }
    // MARK: - Load Nearby Cars
    func loadNearbyCars() {
        interactor.getNearbyCars(around: mapRegion.center)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cars in
                self?.nearbyCars = cars
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Select Pickup
    func selectPickup(_ item: MKMapItem) {
        pickupLocation = LocationEntity(
            coordinate: item.placemark.coordinate,
            title: item.name ?? "",
            subtitle: item.placemark.title
        )
        pickupQuery = item.name ?? ""
        pickupSuggestions = []
        
        // Update map region to show pickup
        updateMapRegion()
    }

    // MARK: - Select Destination
    func selectDestination(_ item: MKMapItem) {
        destinationLocation = LocationEntity(
            coordinate: item.placemark.coordinate,
            title: item.name ?? "",
            subtitle: item.placemark.title
        )
        destinationQuery = item.name ?? ""
        destinationSuggestions = []
        
        // Update map region to show both locations
        updateMapRegion()
    }

    // MARK: - Bind Search
    private func bindSearch() {
        // Pickup search
        $pickupQuery
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] query -> AnyPublisher<[MKMapItem], Never> in
                guard let self = self, !query.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.locationSearchService.search(
                    query: query,
                    region: self.mapRegion
                )
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$pickupSuggestions)
        
        // Destination search
        $destinationQuery
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] query -> AnyPublisher<[MKMapItem], Never> in
                guard let self = self, !query.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.locationSearchService.search(
                    query: query,
                    region: self.mapRegion
                )
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$destinationSuggestions)
    }
    
    // MARK: - Observe Location Changes
    private func observeLocationChanges() {
        // When both locations are set, calculate route and estimate
        Publishers.CombineLatest($pickupLocation, $destinationLocation)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] pickup, destination in
                guard let self = self,
                      let pickup = pickup,
                      let destination = destination else {
                    return
                }
                
                // Calculate route
                self.calculateRouteAndEstimate(from: pickup, to: destination)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Calculate Route and Estimate
    private func calculateRouteAndEstimate(from pickup: LocationEntity, to destination: LocationEntity) {
        // Calculate curved route
        interactor.createCurvedRoute(from: pickup.coordinate, to: destination.coordinate)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Route error: \(error)")
                }
            } receiveValue: { [weak self] route in
                self?.selectedRoute = route
            }
            .store(in: &cancellables)
        
        // Calculate ride estimate
        guard let carType = selectedCarType else { return }
        
        interactor.calculateRideEstimate(
            from: pickup.coordinate,
            to: destination.coordinate,
            carType: carType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error calculating estimate: \(error)")
            }
        } receiveValue: { [weak self] estimate in
            self?.rideEstimate = estimate
        }
        .store(in: &cancellables)
    }

    // MARK: - Select Car Type
    func selectCarType(_ carType: CarTypeEntity) {
        selectedCarType = carType
        
        // Recalculate estimate with new car type
        if let pickup = pickupLocation,
           let destination = destinationLocation {
            interactor.calculateRideEstimate(
                from: pickup.coordinate,
                to: destination.coordinate,
                carType: carType
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error calculating estimate: \(error)")
                }
            } receiveValue: { [weak self] estimate in
                self?.rideEstimate = estimate
            }
            .store(in: &cancellables)
        }
    }
    
    // MARK: - Book Ride
    
     func bookRide() {
         guard let pickup = pickupLocation,
               let destination = destinationLocation,
               let carType = selectedCarType else {
             print("❌ Missing required data for booking")
             return
         }
         
         // Generate random driver info
         let drivers = [
             ("John Smith", "+1 234-567-8901", "john.smith@driver.com"),
             ("Sarah Johnson", "+1 234-567-8902", "sarah.j@driver.com"),
             ("Mike Wilson", "+1 234-567-8903", "mike.w@driver.com"),
             ("Emma Davis", "+1 234-567-8904", "emma.d@driver.com")
         ]
         let randomDriver = drivers.randomElement()!
         
         let booking = RideBookingModel(
            pickupTitle: pickup.title ?? "Unknown",
            pickupLatitude: pickup.coordinate.latitude,
             pickupLongitude: pickup.coordinate.longitude,
             destinationTitle: destination.title ?? "Unknown",
             destinationLatitude: destination.coordinate.latitude,
             destinationLongitude: destination.coordinate.longitude,
             carTypeName: carType.name,
             estimatedDistance: estimatedDistance,
             estimatedTime: estimatedTime,
             estimatedPrice: estimatedPrice,
             driverName: randomDriver.0,
             driverPhone: randomDriver.1,
             driverEmail: randomDriver.2
         )
         
         // Store pending booking and show payment selection
         pendingBooking = booking
         showPaymentSelection = true
     }

     // Add this new method to complete booking after payment selection
     func completeBooking(with paymentCard: PaymentCardModel) {
         guard let booking = pendingBooking,
               let context = modelContext else { return }
         
         // Update booking with payment info
         booking.paymentMethod = paymentCard.maskedCardNumber
         
         context.insert(booking)
         
         do {
             try context.save()
             print("✅ Ride booked successfully with payment: \(paymentCard.maskedCardNumber)")
             navigateToConfirmation = booking
             pendingBooking = nil
             showPaymentSelection = false
         } catch {
             print("❌ Failed to save booking: \(error)")
         }
     }

     // MARK: - Reset Ride State
     func resetRideState() {
         pickupLocation = nil
         destinationLocation = nil
         
         pickupQuery = ""
         destinationQuery = ""
         
         pickupSuggestions = []
         destinationSuggestions = []
         
         selectedRoute = nil
         rideEstimate = nil
         
         selectedCarType = CarTypeEntity.mini   // default again
         
         // Reset map to default region
         mapRegion = MKCoordinateRegion(
             center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
             span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         )
     }

    // MARK: - Update Map Region
    private func updateMapRegion() {
        if let pickup = pickupLocation, let destination = destinationLocation {
            // Calculate center point between pickup and destination
            let centerLat = (pickup.coordinate.latitude + destination.coordinate.latitude) / 2
            let centerLon = (pickup.coordinate.longitude + destination.coordinate.longitude) / 2
            
            // Calculate span to fit both locations with some padding
            let latDelta = abs(pickup.coordinate.latitude - destination.coordinate.latitude) * 2.0
            let lonDelta = abs(pickup.coordinate.longitude - destination.coordinate.longitude) * 2.0
            
            let span = MKCoordinateSpan(
                latitudeDelta: max(latDelta, 0.02),
                longitudeDelta: max(lonDelta, 0.02)
            )
            
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                span: span
            )
        } else if let pickup = pickupLocation {
            // Only pickup is set, center on it
            mapRegion = MKCoordinateRegion(
                center: pickup.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        } else if let destination = destinationLocation {
            // Only destination is set, center on it
            mapRegion = MKCoordinateRegion(
                center: destination.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
}
