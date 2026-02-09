//
//  RideDetailsView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import SwiftUI

struct RideDetailsView: View {
    
    @StateObject var presenter: RideDetailsPresenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if presenter.isLoading && presenter.rideDetails == nil {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if let ride = presenter.rideDetails {
                            // Header
                            headerSection(ride: ride)
                            
                            // Trip Summary
                            tripSummaryCard(ride: ride)
                            
                            // Driver & Vehicle Info
                            driverVehicleCard(ride: ride)
                            
                            // Route Details
                            routeDetailsCard(ride: ride)
                            
                            // Fare Breakdown
                            fareBreakdownCard(ride: ride)
                            
                            // Feedback Section (only for completed rides)
                            if ride.status == .completed {
                                feedbackSection()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Ride Details")
        .alert("Error", isPresented: Binding(
            get: { presenter.errorMessage != nil },
            set: { if !$0 { presenter.errorMessage = nil } }
        )) {
            Button("OK") {
                presenter.errorMessage = nil
            }
        } message: {
            Text(presenter.errorMessage ?? "")
        }
        .alert("Success", isPresented: $presenter.showSuccessAlert) {
            Button("OK") {
                presenter.showSuccessAlert = false
                presenter.router.navigateToHome()
            }
        } message: {
            Text(presenter.successMessage)
        }
        .onAppear {
            presenter.onViewAppear()
        }
        .navigationDestination(
            isPresented: $presenter.shouldNavigateToRideDetails
        ) {
            RideDetailsBuilder.build(rideId: presenter.rideId)
        }

    }
    
    // MARK: - Header Section
    private func headerSection(ride: RideDetails) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Ride ID: #\(ride.rideId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                statusBadge(status: ride.status)
            }
            
            HStack {
                Text("Booking ID: #\(ride.bookingId)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Trip Summary Card
    private func tripSummaryCard(ride: RideDetails) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title)
                Text("Ride Completed")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 30) {
                VStack(spacing: 5) {
                    Image(systemName: "map")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    Text(ride.distance)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 5) {
                    Image(systemName: "clock")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    Text(ride.duration)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 5) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    Text(ride.fare)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Fare")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Driver & Vehicle Card
    private func driverVehicleCard(ride: RideDetails) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.yellow)
                Text("Driver & Vehicle Details")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 15) {
                Image(systemName: ride.driverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(ride.driverName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(ride.driverPhone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 15) {
                        Label(ride.carName, systemImage: "car.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(ride.carNumber)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Route Details Card
    private func routeDetailsCard(ride: RideDetails) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(.yellow)
                Text("Route Details")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                }
                
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pickup Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(ride.pickupLocation)
                            .font(.body)
                            .fontWeight(.medium)
                        Text(formatTime(ride.startTime))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Drop Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(ride.dropLocation)
                            .font(.body)
                            .fontWeight(.medium)
                        if let endTime = ride.endTime {
                            Text(formatTime(endTime))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Fare Breakdown Card
    private func fareBreakdownCard(ride: RideDetails) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.yellow)
                Text("Fare Breakdown")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 8) {
                fareRow(title: "Base Fare", amount: "$10.00")
                fareRow(title: "Distance (\(ride.distance))", amount: "$30.00")
                fareRow(title: "Time (\(ride.duration))", amount: "$5.00")
                
                Divider()
                
                HStack {
                    Text("Total Fare")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(ride.fare)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func fareRow(title: String, amount: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.gray)
            Spacer()
            Text(amount)
                .font(.body)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Feedback Section
    private func feedbackSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Rate Your Experience")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Star Rating
            HStack(spacing: 15) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= presenter.selectedRating ? "star.fill" : "star")
                        .font(.system(size: 35))
                        .foregroundColor(index <= presenter.selectedRating ? .yellow : .gray.opacity(0.3))
                        .onTapGesture {
                            presenter.selectRating(index)
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            
            // Feedback Text
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Feedback")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextEditor(text: $presenter.feedbackText)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Submit Button
            Button(action: {
                presenter.submitFeedback()
            }) {
                HStack {
                    if presenter.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Submit Feedback")
                            .fontWeight(.bold)
                    }
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(12)
            }
            .disabled(presenter.isLoading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Helper Views
    private func statusBadge(status: RideStatus) -> some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor(for: status).opacity(0.2))
            .foregroundColor(statusColor(for: status))
            .cornerRadius(12)
    }
    
    private func statusColor(for status: RideStatus) -> Color {
        switch status {
        case .ongoing: return .blue
        case .completed: return .green
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RideDetailsBuilder.build(rideId: "RIDE123456")
    }
}
