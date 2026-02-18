//
//  HomeInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import Foundation
import Combine
import CoreLocation
import MapKit

// MARK: - Home Interactor Protocol
protocol HomeInteractorProtocol {
    func getNearbyCars(around location: CLLocationCoordinate2D) -> AnyPublisher<[TaxiCarEntity], Never>
    func calculateRideEstimate(from pickup: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, carType: CarTypeEntity) -> AnyPublisher<RideEstimateEntity, Error>
    func createCurvedRoute(from pickup: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> AnyPublisher<RouteEntity, Error>
}

// MARK: - Home Interactor
class HomeInteractor: HomeInteractorProtocol {
    func createCurvedRoute(from pickup: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> AnyPublisher<RouteEntity, Error> {
        return Future<RouteEntity, Error> { promise in
            // Create curved route using bezier curve
            let points = self.createBezierCurve(
                start: pickup,
                end: destination,
                numberOfPoints: 50
            )
            
            var coordinates = points.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            
            // Calculate distance
            var totalDistance = 0.0
            for i in 0..<(points.count - 1) {
                let start = points[i]
                let end = points[i + 1]
                let distance = self.calculateDistance(from: start, to: end)
                totalDistance += distance
            }
            
            let route = RouteEntity(
                polyline: polyline,
                distance: totalDistance,
                duration: totalDistance / 10 // Rough estimate: 10 m/s average speed
            )
            
            promise(.success(route))
        }
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Get Nearby Cars
    func getNearbyCars(around location: CLLocationCoordinate2D) -> AnyPublisher<[TaxiCarEntity], Never> {
        // Simulate nearby cars with different positions and routes
        let cars = [
            TaxiCarEntity(
                coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude + 0.008,
                    longitude: location.longitude - 0.005
                ),
                driverName: "John Doe",
                carNumber: "ABC 123",
                bearing: 45,
                rating: 4.8,
                isAvailable: true,
                destinationCoordinate: CLLocationCoordinate2D(
                    latitude: location.latitude + 0.015,
                    longitude: location.longitude + 0.010
                )
            ),
            TaxiCarEntity(
                coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude - 0.010,
                    longitude: location.longitude + 0.008
                ),
                driverName: "Jane Smith",
                carNumber: "XYZ 789",
                bearing: 135,
                rating: 4.9,
                isAvailable: true,
                destinationCoordinate: CLLocationCoordinate2D(
                    latitude: location.latitude - 0.005,
                    longitude: location.longitude - 0.012
                )
            ),
            TaxiCarEntity(
                coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude + 0.012,
                    longitude: location.longitude + 0.015
                ),
                driverName: "Mike Johnson",
                carNumber: "DEF 456",
                bearing: 225,
                rating: 4.7,
                isAvailable: true,
                destinationCoordinate: nil
            ),
            TaxiCarEntity(
                coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude - 0.015,
                    longitude: location.longitude - 0.010
                ),
                driverName: "Sarah Williams",
                carNumber: "GHI 321",
                bearing: 315,
                rating: 5.0,
                isAvailable: true,
                destinationCoordinate: CLLocationCoordinate2D(
                    latitude: location.latitude + 0.005,
                    longitude: location.longitude + 0.008
                )
            )
        ]
        
        return Just(cars).eraseToAnyPublisher()
    }
    
    // MARK: - Calculate Ride Estimate
    func calculateRideEstimate(from pickup: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, carType: CarTypeEntity) -> AnyPublisher<RideEstimateEntity, Error> {
        Future<RideEstimateEntity, Error> { promise in
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickup))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let route = response?.routes.first else {
                    promise(.failure(NSError(domain: "RouteError", code: 404)))
                    return
                }
                
                let distanceInKm = route.distance / 1000
                let price = carType.basePrice + (distanceInKm * carType.pricePerKm)
                
                let estimate = RideEstimateEntity(
                    distance: route.distance,
                    duration: route.expectedTravelTime,
                    price: price,
                    carType: carType
                )
                
                promise(.success(estimate))
            }
        }
        .eraseToAnyPublisher()
    }
    // MARK: - Create Bezier Curve Points
    private func createBezierCurve(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, numberOfPoints: Int) -> [CLLocation] {
        var points: [CLLocation] = []
        
        // Create control points for bezier curve
        let midLat = (start.latitude + end.latitude) / 2
        let midLon = (start.longitude + end.longitude) / 2
        
        // Offset the control point to create curve
        let offsetLat = (end.longitude - start.longitude) * 0.3
        let offsetLon = -(end.latitude - start.latitude) * 0.3
        
        let controlPoint = CLLocationCoordinate2D(
            latitude: midLat + offsetLat,
            longitude: midLon + offsetLon
        )
        
        // Generate points along the curve
        for i in 0...numberOfPoints {
            let t = Double(i) / Double(numberOfPoints)
            
            // Quadratic Bezier curve formula: B(t) = (1-t)²P0 + 2(1-t)tP1 + t²P2
            let lat = pow(1 - t, 2) * start.latitude +
                     2 * (1 - t) * t * controlPoint.latitude +
                     pow(t, 2) * end.latitude
            
            let lon = pow(1 - t, 2) * start.longitude +
                     2 * (1 - t) * t * controlPoint.longitude +
                     pow(t, 2) * end.longitude
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            points.append(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        return points
    }
    
    // MARK: - Calculate Distance
    private func calculateDistance(from start: CLLocation, to end: CLLocation) -> Double {
        return start.distance(from: end)
    }
}

