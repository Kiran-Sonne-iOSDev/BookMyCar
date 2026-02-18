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
    @State private var dragOffset: CGFloat = 0
    @State private var sheetHeight: SheetHeight = .half

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
            .sheet(isPresented: $presenter.showPaymentSelection) {
                if let booking = presenter.pendingBooking {
                    PaymentSelectionView(
                        booking: booking,
                        onPaymentSelected: { card in
                            presenter.completeBooking(with: card)
                        },
                        onNonCardPayment: { booking in
                            presenter.completeBookingWithoutCard(booking: booking)
                        }
                    )
                }
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
}

// MARK: - Sheet Height Enum
enum SheetHeight {
    case quarter
    case half
    case full
    
    var value: CGFloat {
        switch self {
        case .quarter: return UIScreen.main.bounds.height * 0.25
        case .half: return UIScreen.main.bounds.height * 0.5
        case .full: return UIScreen.main.bounds.height * 0.85
        }
    }
}

// MARK: - Enhanced Bottom Sheet Extension
extension HomeView {
    
    // MARK: - Bottom Sheet View
    var bottomSheetView: some View {
        VStack(spacing: 0) {
            dragHandle
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    enhancedLocationInputSection
                    
                    if presenter.pickupLocation != nil && presenter.destinationLocation != nil {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        enhancedCarSelectionSection
                        rideDetailsSection
                        enhancedBookingButton
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxHeight: sheetHeight.value - 60)
        }
        .frame(maxWidth: .infinity)
        .frame(height: sheetHeight.value + dragOffset)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: -5)
        )
        .offset(y: max(dragOffset, -50))
        .gesture(
            DragGesture()
                .onChanged { value in
                    let translation = value.translation.height
                    dragOffset = translation
                }
                .onEnded { value in
                    let translation = value.translation.height
                    let velocity = value.predictedEndTranslation.height - translation
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        if translation < -100 || velocity < -500 {
                            if sheetHeight == .half {
                                sheetHeight = .full
                            } else if sheetHeight == .quarter {
                                sheetHeight = .half
                            }
                        } else if translation > 100 || velocity > 500 {
                            if sheetHeight == .full {
                                sheetHeight = .half
                            } else if sheetHeight == .half {
                                sheetHeight = .quarter
                            }
                        }
                        dragOffset = 0
                    }
                }
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: sheetHeight)
    }
    
    // MARK: - Enhanced Drag Handle
    var dragHandle: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            if sheetHeight != .full {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(.gray.opacity(0.6))
                .padding(.bottom, 8)
            }
        }
    }
    
    // MARK: - Enhanced Location Input Section
    var enhancedLocationInputSection: some View {
        VStack(spacing: 16) {
            // Pickup Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(Color.green.opacity(0.3), lineWidth: 4)
                        )
                    
                    TextField("Pickup location", text: $presenter.pickupQuery)
                        .font(.system(size: 16, weight: .medium))
                    
                    if !presenter.pickupQuery.isEmpty {
                        Button {
                            presenter.pickupQuery = ""
                            presenter.pickupLocation = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.2), lineWidth: 1)
                        )
                )
                
                if !presenter.pickupSuggestions.isEmpty {
                    enhancedSuggestionsList(
                        suggestions: presenter.pickupSuggestions,
                        onSelect: { item in
                            presenter.selectPickup(item)
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            // Destination Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.red.opacity(0.3), lineWidth: 4)
                        )
                    
                    TextField("Where to?", text: $presenter.destinationQuery)
                        .font(.system(size: 16, weight: .medium))
                    
                    if !presenter.destinationQuery.isEmpty {
                        Button {
                            presenter.destinationQuery = ""
                            presenter.destinationLocation = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.2), lineWidth: 1)
                        )
                )
                
                if !presenter.destinationSuggestions.isEmpty {
                    enhancedSuggestionsList(
                        suggestions: presenter.destinationSuggestions,
                        onSelect: { item in
                            presenter.selectDestination(item)
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Enhanced Suggestions List
    func enhancedSuggestionsList(suggestions: [MKMapItem], onSelect: @escaping (MKMapItem) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(suggestions.indices, id: \.self) { index in
                let item = suggestions[index]
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        onSelect(item)
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.5))
                        
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
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                }
                
                if index != suggestions.count - 1 {
                    Divider()
                        .padding(.leading, 48)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        .padding(.top, 4)
    }
    
    // MARK: - Enhanced Car Selection Section
    var enhancedCarSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Choose a ride")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if presenter.pickupLocation != nil && presenter.destinationLocation != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text(presenter.estimatedTime)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(presenter.carTypes) { carType in
                        EnhancedCarTypeCard(
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
    
    // MARK: - Ride Details Section (Keep Original)
    var rideDetailsSection: some View {
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
    
    // MARK: - Enhanced Booking Button
    var enhancedBookingButton: some View {
        Button(action: {
            withAnimation {
                presenter.bookRide()
                print("Total rides:", rides.count)
            }
        }) {
            HStack(spacing: 12) {
                Text("Confirm")
                    .font(.system(size: 18, weight: .bold))
                
                Text(presenter.selectedCarType?.name ?? "Ride")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.black, Color.gray.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

