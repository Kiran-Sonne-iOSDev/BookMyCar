//
//  MyRidesPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData
import Combine

class MyRidesPresenter: ObservableObject {
    @Published var groupedRides: [Date: [RideBookingModel]] = [:]
    @Published var sortedDates: [Date] = []
    
    var modelContext: ModelContext?
    
    func fetchRides() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<RideBookingModel>(
            sortBy: [SortDescriptor(\.bookingDate, order: .reverse)]
        )
        
        do {
            let rides = try context.fetch(descriptor)
            groupRidesByDate(rides)
        } catch {
            print("❌ Failed to fetch rides: \(error)")
        }
    }
    
    func deleteRide(_ ride: RideBookingModel) {
        guard let context = modelContext else { return }
        
        context.delete(ride)
        
        do {
            try context.save()
            print("✅ Ride deleted successfully")
            fetchRides() // Refresh the list
        } catch {
            print("❌ Failed to delete ride: \(error)")
        }
    }
    private func groupRidesByDate(_ rides: [RideBookingModel]) {
        let calendar = Calendar.current
        
        // Group rides by date (ignoring time)
        let grouped = Dictionary(grouping: rides) { ride in
            calendar.startOfDay(for: ride.bookingDate)
        }
        
        self.groupedRides = grouped
        self.sortedDates = grouped.keys.sorted(by: >)
    }
    
    func toggleFavorite(for ride: RideBookingModel) {
           guard let context = modelContext else { return }
           
           ride.isFavorite.toggle()
           
           do {
               try context.save()
               print("✅ Favorite toggled: \(ride.isFavorite)")
           } catch {
               print("❌ Failed to toggle favorite: \(error)")
           }
       }
       
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
