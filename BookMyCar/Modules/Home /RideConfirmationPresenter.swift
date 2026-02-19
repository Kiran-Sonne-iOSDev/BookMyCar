//
//  RideConfirmationPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//
import Combine
import SwiftData
class RideConfirmationPresenter: ObservableObject {
    let booking: RideBookingModel
    @Published var selectedRating: Int = 0
    @Published var showThankYouAlert = false
    @Published var shouldDismiss = false
    
    init(booking: RideBookingModel) {
        self.booking = booking
    }
    
    func submitRating(context: ModelContext) {
        guard selectedRating > 0 else { return }
        
        // Save rating to booking
        booking.rating = selectedRating
        
        do {
            try context.save()
            print("✅ Rating saved: \(selectedRating) stars")
            
            // Show alert
            showThankYouAlert = true
            
        } catch {
            print("❌ Failed to save rating: \(error)")
        }
    }
    func toggleFavorite(context: ModelContext) {
        booking.isFavorite.toggle()
        
        do {
            try context.save()
            print("✅ Favorite toggled: \(booking.isFavorite)")
        } catch {
            print("❌ Failed to toggle favorite: \(error)")
        }
    }
}
