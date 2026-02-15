//
//  RideBookingEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData

@Model
final class RideBookingModel: Identifiable {

    var id: UUID
    var pickupTitle: String
    var pickupLatitude: Double
    var pickupLongitude: Double
    
    var destinationTitle: String
    var destinationLatitude: Double
    var destinationLongitude: Double
    
    var carTypeName: String
    var estimatedDistance: String
    var estimatedTime: String
    var estimatedPrice: String
    
    var bookingDate: Date
    var driverName: String
    var driverPhone: String
    var driverEmail: String
    var rating: Int?
    var isFavorite: Bool = false
    
    init(
        pickupTitle: String,
        pickupLatitude: Double,
        pickupLongitude: Double,
        destinationTitle: String,
        destinationLatitude: Double,
        destinationLongitude: Double,
        carTypeName: String,
        estimatedDistance: String,
        estimatedTime: String,
        estimatedPrice: String,
        driverName: String,
        driverPhone: String,
        driverEmail: String
    ) {
        self.id = UUID()
        self.pickupTitle = pickupTitle
        self.pickupLatitude = pickupLatitude
        self.pickupLongitude = pickupLongitude
        self.destinationTitle = destinationTitle
        self.destinationLatitude = destinationLatitude
        self.destinationLongitude = destinationLongitude
        self.carTypeName = carTypeName
        self.estimatedDistance = estimatedDistance
        self.estimatedTime = estimatedTime
        self.estimatedPrice = estimatedPrice
        self.driverName = driverName
        self.driverPhone = driverPhone
        self.driverEmail = driverEmail
        self.bookingDate = Date()
        self.isFavorite = false
        
    }
}
