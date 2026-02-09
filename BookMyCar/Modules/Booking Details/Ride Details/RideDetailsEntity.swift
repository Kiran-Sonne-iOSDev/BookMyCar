//
//  RideDetailsEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
struct RideDetails {
    let rideId: String
    let bookingId: String
    let carName: String
    let carNumber: String
    let driverName: String
    let driverPhone: String
    let driverImage: String
    let pickupLocation: String
    let dropLocation: String
    let fare: String
    let distance: String
    let duration: String
    let startTime: Date
    let endTime: Date?
    let status: RideStatus
}

enum RideStatus: String {
    case ongoing = "Ongoing"
    case completed = "Completed"
    
    var color: String {
        switch self {
        case .ongoing: return "blue"
        case .completed: return "green"
        }
    }
}
