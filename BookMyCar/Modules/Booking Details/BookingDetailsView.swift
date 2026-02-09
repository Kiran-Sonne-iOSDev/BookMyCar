//
//  BookingDetailsView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

 import SwiftUI

struct BookingDetailsView: View {
    
    @StateObject var presenter: BookingDetailsPresenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if presenter.isLoading && presenter.bookingDetails == nil {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if let booking = presenter.bookingDetails {
                            // Trip Details Card
                            tripDetailsCard(booking: booking)
                            // Header Section
                            headerSection(booking: booking)
                            // Driver Details Card
                            driverDetailsCard(booking: booking)
                            // Fare Card
                            fareCard(booking: booking)
                            // Book Ride Button
                            bookRideButton()
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Booking Details")
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
        .onAppear {
            presenter.onViewAppear()
        }
        
    }
    
    // MARK: - Header Section
    private func headerSection(booking: BookingDetails) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Booking ID: #\(booking.bookingId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                statusBadge(status: booking.status)
            }
            
            Text(formatDate(booking.bookingDate))
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Driver Details Card
    private func driverDetailsCard(booking: BookingDetails) -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                // Driver Image
                Image(systemName: booking.driverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Driver Details")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(booking.driverName)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text(booking.driverPhone)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    presenter.callDriver()
                }) {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                }
            }
            
            Divider()
            
            // Vehicle Details
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.yellow)
                    Text("Vehicle Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Car Name")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(booking.carName)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Car Number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(booking.carNumber)
                            .font(.body)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Trip Details Card
    private func tripDetailsCard(booking: BookingDetails) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(.yellow)
                Text("Trip Details")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            // Pickup Location
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 30)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pickup Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(booking.pickupLocation)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Drop Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(booking.dropLocation)
                            .font(.body)
                            .fontWeight(.medium)
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
    
    // MARK: - Fare Card
    private func fareCard(booking: BookingDetails) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Total Fare")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(booking.fare)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Image(systemName: "creditcard.fill")
                .font(.system(size: 30))
                .foregroundColor(.yellow)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Book Ride Button
    private func bookRideButton() -> some View {
        Button(action: {
            presenter.bookRide()
        }) {
            Text("Book Ride")
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Views
    private func statusBadge(status: BookingStatus) -> some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor(for: status).opacity(0.2))
            .foregroundColor(statusColor(for: status))
            .cornerRadius(12)
    }
    
    private func statusColor(for status: BookingStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .ongoing: return .blue
        case .completed: return .green
        case .cancelled: return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        BookingDetailsBuilder.build(bookingId: "BK123456")
    }
}
