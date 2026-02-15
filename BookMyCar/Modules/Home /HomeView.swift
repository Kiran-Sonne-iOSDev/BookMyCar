//
//   Map View.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//
import SwiftUI
import MapKit
import SwiftData
import Foundation

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var rides: [RideBookingModel]

    @StateObject private var presenter: HomePresenter
    @State private var showBottomSheet = true
    @State private var isSideMenuShowing = false
 
    init(presenter: HomePresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                HomeMapView(
                    region: $presenter.mapRegion,
                    nearbyCars: presenter.nearbyCars,
                    selectedRoute: presenter.selectedRoute,
                    pickupLocation: presenter.pickupLocation,
                    destinationLocation: presenter.destinationLocation
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top Menu Button
                    topMenuButton
                    
                    Spacer()
                    
                    // Bottom Sheet
                    if showBottomSheet {
                        bottomSheetView
                            .transition(.move(edge: .bottom))
                    }
                }
                
                // Side Menu
                SideMenuView(isShowing: $isSideMenuShowing)
            }
            .onAppear {
                presenter.modelContext = modelContext
                // ✅ Load user session
                UserSession.shared.loadSession(context: modelContext)
                presenter.loadNearbyCars()
                
                if presenter.navigateToConfirmation == nil {
                       presenter.resetRideState()
                   }
            }
            .navigationDestination(item: $presenter.navigateToConfirmation) { booking in
                RideConfirmationView(
                    presenter: RideConfirmationPresenter(booking: booking)
                )
            }
        }
    }
    
    // MARK: - Top Menu Button
    private var topMenuButton: some View {
        HStack {
            Button {
                withAnimation {
                    isSideMenuShowing = true
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
    
    // MARK: - Bottom Sheet View
    private var bottomSheetView: some View {
        VStack(spacing: 0) {
            // Drag Handle
            dragHandle
            
            // Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Location Input Section
                    locationInputSection
                    
                    // Car Selection & Booking Section (only show when both locations selected)
                    if presenter.pickupLocation != nil && presenter.destinationLocation != nil {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        carSelectionSection
                        rideDetailsSection
                        bookingButton
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
    
    // MARK: - Drag Handle
    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 40, height: 5)
            .padding(.top, 12)
            .padding(.bottom, 20)
    }
    
    // MARK: - Location Input Section
    private var locationInputSection: some View {
        VStack(spacing: 16) {
            // Pickup Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                    
                    TextField("Pickup location", text: $presenter.pickupQuery)
                        .font(.system(size: 16))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Pickup Suggestions
                if !presenter.pickupSuggestions.isEmpty {
                    suggestionsList(
                        suggestions: presenter.pickupSuggestions,
                        onSelect: { item in
                            presenter.selectPickup(item)
                        }
                    )
                }
            }
            
            // Destination Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                    
                    TextField("Destination Location", text: $presenter.destinationQuery)
                        .font(.system(size: 16))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Destination Suggestions
                if !presenter.destinationSuggestions.isEmpty {
                    suggestionsList(
                        suggestions: presenter.destinationSuggestions,
                        onSelect: { item in
                            presenter.selectDestination(item)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Suggestions List
    private func suggestionsList(suggestions: [MKMapItem], onSelect: @escaping (MKMapItem) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(suggestions.indices, id: \.self) { index in
                let item = suggestions[index]
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onSelect(item)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name ?? "Unknown")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                        
                        if let subtitle = item.placemark.title, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
                
                if index != suggestions.count - 1 {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .padding(.top, 4)
    }
    
    // MARK: - Car Selection Section
    private var carSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Car Type")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(presenter.carTypes) { carType in
                        CarTypeCard(
                            carType: carType,
                            isSelected: presenter.selectedCarType?.id == carType.id
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                presenter.selectCarType(carType)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Ride Details Section
    private var rideDetailsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                RideDetailItem(
                    icon: "location.fill",
                    title: "Distance",
                    value: presenter.estimatedDistance
                )
                
                RideDetailItem(
                    icon: "clock.fill",
                    title: "Time",
                    value: presenter.estimatedTime
                )
                
                RideDetailItem(
                    icon: "dollarsign.circle.fill",
                    title: "Price",
                    value: presenter.estimatedPrice
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Booking Button
    private var bookingButton: some View {
        Button(action: {
            withAnimation {
                presenter.bookRide()
                print("Total rides:", rides.count)

            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "car.fill")
                    .font(.system(size: 18, weight: .semibold))

                Text("Book Ride")
                    .font(.system(size: 18, weight: .bold))
 
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

// MARK: - Car Type Card
struct CarTypeCard: View {
    let carType: CarTypeEntity
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Car Icon
                Image(systemName: carType.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .black : .gray)
                
                // Car Name
                Text(carType.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .black : .gray)
                
                // Price
                Text(carType.priceRange)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "FFD700") : .gray)
                
                // Capacity
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 10))
                    Text("\(carType.capacity)")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(isSelected ? .black.opacity(0.7) : .gray)
            }
            .frame(width: 100)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "FFF9E6") : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "FFD700") : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Ride Detail Item
struct RideDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "0066FF"))
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

