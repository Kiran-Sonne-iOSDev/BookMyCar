//
//  RideDetailsInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation

final class RideDetailsInteractor: RideDetailsInteractorProtocol {
    
    weak var presenter: RideDetailsInteractorOutputProtocol?
    
    func fetchRideDetails(rideId: String) {
        // Mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let mockRide = RideDetails(
                rideId: rideId,
                bookingId: "BK123456",
                carName: "Toyota Camry",
                carNumber: "MH 15 AB 1234",
                driverName: "Rajesh Kumar",
                driverPhone: "+91 98765 43210",
                driverImage: "person.circle.fill",
                pickupLocation: "Lokmat Square, Nashik",
                dropLocation: "Mumbai Airport Terminal 2",
                fare: "$45.00",
                distance: "250 km",
                duration: "3h 45min",
                startTime: Date(),
                endTime: Date().addingTimeInterval(13500), // 3h 45min later
                status: .completed
            )
            self?.presenter?.didFetchRideDetails(mockRide)
        }
    }
    
    func submitFeedback(rideId: String, rating: Int, comment: String) {
        // Mock API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.presenter?.didSubmitFeedback()
        }
    }
}
