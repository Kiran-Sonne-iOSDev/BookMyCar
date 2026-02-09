//
//  HomePresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Combine
import SwiftUI

final class HomePresenter: ObservableObject {
    
    // MARK: - UI State
    @Published var vehicles: [Vehicle] = []
    @Published var selectedVehicleType: VehicleType = .economy
    @Published var estimatedFare: String = "$12"
    @Published var estimatedTime: String = "5 mins"
    @Published var pickupLocation: String = "Current Location"
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(interactor: HomeInteractorProtocol,
         router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presenter Protocol
extension HomePresenter: HomePresenterProtocol {
    
    func onViewAppear() {
        isLoading = true
        interactor.fetchNearbyVehicles()
    }
    
    func selectVehicleType(_ type: VehicleType) {
        selectedVehicleType = type
        interactor.calculateFare(from: pickupLocation, to: "Destination", vehicleType: type)
    }
    
    func bookRide() {
        router.navigateToBookingDetails()
    }
}
extension HomePresenter: HomeInteractorOutputProtocol {
    
    func didFetchVehicles(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
        isLoading = false
        // Set estimated time from nearest vehicle
        if let nearest = vehicles.first {
            estimatedTime = nearest.estimatedTime
        }
    }
    
    func didCalculateFare(_ fare: Double) {
        estimatedFare = String(format: "$%.0f", fare)
    }
    
    func didFailWithError(_ error: String) {
        errorMessage = error
        isLoading = false
    }
}
