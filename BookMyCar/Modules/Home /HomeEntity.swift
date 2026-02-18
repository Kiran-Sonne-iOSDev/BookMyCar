//
//  HomeEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Taxi Car Entity
struct TaxiCarEntity: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let driverName: String
    let carNumber: String
    var bearing: Double // rotation angle in degrees
    let rating: Double
    let isAvailable: Bool
    
    // Simulated route to destination
    var destinationCoordinate: CLLocationCoordinate2D?
}

// MARK: - Car Type Entity
struct CarTypeEntity: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let priceRange: String
    let capacity: Int
    let basePrice: Double
    let pricePerKm: Double
    let icon: String
    let isSystemIcon: Bool
    
    
    
    static let auto = CarTypeEntity(
        name: "Auto",
        priceRange: "Rs.100-500",
        capacity: 2,
        basePrice: 5.0,
        pricePerKm: 1.0,
        icon: "auto-rickshaw",
        isSystemIcon: false
    )
    
    
    static let mini = CarTypeEntity(
        name: "Mini",
        priceRange: "Rs.200-1000",
        capacity: 4,
        basePrice: 5.0,
        pricePerKm: 1.2,
        icon: "car.fill",
        isSystemIcon: true
    )
    
    static let sedan = CarTypeEntity(
        name: "Sedan",
        priceRange: "Rs.450-1500",
        capacity: 4,
        basePrice: 10.0,
        pricePerKm: 1.5,
        icon: "car.fill",
        isSystemIcon: true
    )
    
    static let suv = CarTypeEntity(
        name: "SUV",
        priceRange: "Rs.550-2000",
        capacity: 6,
        basePrice: 15.0,
        pricePerKm: 2.0,
        icon: "car.fill",
        isSystemIcon: true
    )
    
    static let luxury = CarTypeEntity(
        name: "Luxury",
        priceRange: "Rs.2500-3500",
        capacity: 4,
        basePrice: 25.0,
        pricePerKm: 3.0,
        icon: "car.fill",
        isSystemIcon: true
    )
    
    static let all: [CarTypeEntity] = [auto,mini, sedan, suv, luxury]
}

// MARK: - Ride Estimate Entity
struct RideEstimateEntity {
    let distance: Double // in meters
    let duration: TimeInterval // in seconds
    let price: Double
    let carType: CarTypeEntity
    
    var distanceText: String {
        String(format: "%.1f km", distance / 1000)
    }
    
    var durationText: String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    var priceText: String {
        String(format: "Rs%.2f", price)
    }
}
