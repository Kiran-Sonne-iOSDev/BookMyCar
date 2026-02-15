//
//  FavoritesPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData
import Combine

class FavoritesPresenter: ObservableObject {
    @Published var favoriteRides: [RideBookingModel] = []
    
    var modelContext: ModelContext?
    
    func fetchFavorites() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<RideBookingModel>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.bookingDate, order: .reverse)]
        )
        
        do {
            favoriteRides = try context.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch favorites: \(error)")
        }
    }
    
    func toggleFavorite(for ride: RideBookingModel) {
        guard let context = modelContext else { return }
        
        ride.isFavorite.toggle()
        
        do {
            try context.save()
            fetchFavorites() // Refresh list
        } catch {
            print("❌ Failed to toggle favorite: \(error)")
        }
    }
    
    func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy • hh:mm a"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
