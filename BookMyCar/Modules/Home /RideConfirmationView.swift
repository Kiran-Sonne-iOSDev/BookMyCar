//
//  RideConfirmationView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import SwiftData

struct RideConfirmationView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var presenter: RideConfirmationPresenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Success header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Ride Confirmed")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your driver is on the way")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                bookingSection
                driverSection
                ratingSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .alert("Thank You!", isPresented: $presenter.showThankYouAlert) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Thank you for your feedback! We are happy to serve you again for your next destination.")
                }
    }
    var bookingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Booking Details", systemImage: "car.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // ✅ Favorite Toggle
                Button {
                    presenter.toggleFavorite(context: modelContext)
                } label: {
                    Image(systemName: presenter.booking.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(presenter.booking.isFavorite ? .red : .gray)
                }
            }
            
            VStack(spacing: 12) {
                DetailRow(icon: "car.2.fill", label: "Car Type", value: presenter.booking.carTypeName)
                DetailRow(icon: "map.fill", label: "Distance", value: presenter.booking.estimatedDistance)
                DetailRow(icon: "clock.fill", label: "Time", value: presenter.booking.estimatedTime)
                DetailRow(icon: "dollarsign.circle.fill", label: "Price", value: presenter.booking.estimatedPrice)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    var driverSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Driver Details", systemImage: "person.circle.fill")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                DetailRow(icon: "person.fill", label: "Name", value: presenter.booking.driverName)
                DetailRow(icon: "phone.fill", label: "Phone", value: presenter.booking.driverPhone)
                DetailRow(icon: "envelope.fill", label: "Email", value: presenter.booking.driverEmail)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    var ratingSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Rate Your Ride")
                    .font(.headline)
                
                Text("How was your experience?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= presenter.selectedRating ? "star.fill" : "star")
                        .foregroundColor(index <= presenter.selectedRating ? .yellow : .gray.opacity(0.3))
                        .font(.system(size: 32))
                        .onTapGesture {
                            presenter.selectedRating = index
                        }
                        .animation(.spring(response: 0.3), value: presenter.selectedRating)
                }
            }
            
            Button {
                presenter.submitRating(context: modelContext)
            } label: {
                Text("Submit Rating")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(presenter.selectedRating > 0 ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(presenter.selectedRating == 0)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Helper view for consistent detail rows
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .fontWeight(.medium)
            
            Spacer()
        }
        .font(.subheadline)
    }
}
