//
//  MyRidesView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import SwiftData

struct MyRidesView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var presenter = MyRidesPresenter()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "FF9800"),
                        Color(hex: "FFC107")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    header
                    
                    // Content
                    if presenter.sortedDates.isEmpty {
                        emptyState
                    } else {
                        ridesList
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                presenter.modelContext = modelContext
                presenter.fetchRides()
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text("My Rides")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    // MARK: - Rides List
    private var ridesList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(presenter.sortedDates, id: \.self) { date in
                    VStack(alignment: .leading, spacing: 16) {
                        // Date Header
                        dateHeader(date: date)
                        
                        // Rides for this date
                        if let rides = presenter.groupedRides[date] {
                            ForEach(rides) { ride in
                                VStack(alignment: .leading, spacing: 8) {
                                    // Time stamp
                                    Text(presenter.formatTime(ride.bookingDate))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.yellow)
                                        .cornerRadius(8)
                                    
                                    // Ride Card
                                    RideHistoryCard(
                                        ride: ride,
                                        timeString: presenter.formatTime(ride.bookingDate),
                                        onToggleFavorite: {
                                            presenter.toggleFavorite(for: ride)
                                        },
                                        onToggleTrash: {
                                            presenter.deleteRide(ride)
                                        }
                                    )
                                }
                            }
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    // MARK: - Date Header
    private func dateHeader(date: Date) -> some View {
        HStack {
            Text(presenter.formatDate(date))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.top, 8)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.7))
            
            Text("No rides yet")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Book your first ride to see it here!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
