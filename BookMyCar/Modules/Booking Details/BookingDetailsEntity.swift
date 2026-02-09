//
//  BookingDetailsEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation

struct BookingDetails {
    let bookingId: String
    let carName: String
    let carNumber: String
    let driverName: String
    let driverPhone: String
    let driverImage: String
    let pickupLocation: String
    let dropLocation: String
    let fare: String
    let status: BookingStatus
    let bookingDate: Date
    let rating: Int?
    let feedback: String?
}

enum BookingStatus: String {
    case pending = "Pending"
    case ongoing = "Ongoing"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .ongoing: return "blue"
        case .completed: return "green"
        case .cancelled: return "red"
        }
    }
}

struct FeedbackData {
    let bookingId: String
    let rating: Int
    let comment: String
}
