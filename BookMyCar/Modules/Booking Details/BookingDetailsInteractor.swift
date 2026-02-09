//
//  BookingDetailsInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//


// BookingDetailsInteractor.swift
import Foundation

final class BookingDetailsInteractor: BookingDetailsInteractorProtocol {
    
    weak var presenter: BookingDetailsInteractorOutputProtocol?
    
    func fetchBookingDetails(bookingId: String) {
        // Mock data - Replace with actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let mockBooking = BookingDetails(
                bookingId: bookingId,
                carName: "Toyota Camry",
                carNumber: "MH 15 AB 1234",
                driverName: "Rajesh Kumar",
                driverPhone: "+91 98765 43210",
                driverImage: "person.circle.fill",
                pickupLocation: "Lokmat Square, Nashik",
                dropLocation: "Mumbai Airport Terminal 2",
                fare: "$45.00",
                status: .pending,
                bookingDate: Date(),
                rating: nil,
                feedback: nil
            )
            self?.presenter?.didFetchBookingDetails(mockBooking)
        }
    }
    
    func confirmBooking(bookingId: String) {
        // Mock API call to confirm booking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let rideId = "RIDE\(Int.random(in: 100000...999999))"
            self?.presenter?.didConfirmBooking(rideId)
        }
    }
}
