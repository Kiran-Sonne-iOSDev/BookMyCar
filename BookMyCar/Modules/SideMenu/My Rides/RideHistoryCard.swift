//
//  RideHistoryCard.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI

struct RideHistoryCard: View {
    let ride: RideBookingModel
    let timeString: String
    let onToggleFavorite: () -> Void
    let onToggleTrash: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Pickup Location
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12, height: 12)
                
                Text(ride.pickupTitle)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.8))
                    .lineLimit(1)
                Spacer()
                Button {
                                   showDeleteAlert = true  // Show alert instead of direct delete
                               } label: {
                                   Image(systemName: "trash")
                                       .font(.system(size: 20))
                                       .foregroundColor(.gray)
                               }
                
                
                Button {
                    onToggleFavorite()
                } label: {
                    Image(systemName: ride.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(ride.isFavorite ? .red : .gray)
                }
                
            }
            
            // Destination Location
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12, height: 12)
                
                Text(ride.destinationTitle)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.8))
                    .lineLimit(1)
            }
            
            // Price
            HStack {
                Text(ride.carTypeName)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                HStack(spacing: 20) {
                    Text("Paid via: \(ride.paymentMethod)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.gray)
                    Text(ride.estimatedPrice)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.green.opacity(0.4))
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "E8F5E9"),
                    Color(hex: "FFF9C4").opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .alert("Delete Ride", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        onToggleTrash()
                    }
                } message: {
                    Text("Are you sure you want to delete this ride? This action cannot be undone.")
                }
    }
}
