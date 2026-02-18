//
//  LocationEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Location Entity
struct LocationEntity: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String?
    
    static func == (lhs: LocationEntity, rhs: LocationEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

// MARK: - Route Entity
public struct RouteEntity: Identifiable {
    public let id = UUID()
    public let polyline: MKPolyline
    public let distance: Double // in meters
    public let duration: TimeInterval // in seconds
    
    public init(polyline: MKPolyline, distance: Double, duration: TimeInterval) {
        self.polyline = polyline
        self.distance = distance
        self.duration = duration
    }
    
    public var distanceInKm: String {
        String(format: "%.1f km", distance / 1000)
    }
    
    public var durationInMinutes: String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
}

// MARK: - Ride Request Entity
struct RideRequestEntity {
    let pickupLocation: LocationEntity
    let destinationLocation: LocationEntity
    let timestamp: Date
}
