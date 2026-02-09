//
//  HomeInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation

final class HomeInteractor: HomeInteractorProtocol {
    
    weak var presenter: HomeInteractorOutputProtocol?
    
    func fetchNearbyVehicles() {
        // Mock data - Replace with actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let mockVehicles = [
                Vehicle(id: "1", type: .economy, latitude: 19.9975, longitude: 73.7898, estimatedTime: "2 min", fare: "$12"),
                Vehicle(id: "2", type: .standard, latitude: 20.0005, longitude: 73.7910, estimatedTime: "5 min", fare: "$18"),
                Vehicle(id: "3", type: .luxury, latitude: 19.9985, longitude: 73.7920, estimatedTime: "7 min", fare: "$25"),
                Vehicle(id: "4", type: .economy, latitude: 20.0015, longitude: 73.7905, estimatedTime: "3 min", fare: "$12")
            ]
            self?.presenter?.didFetchVehicles(mockVehicles)
        }
    }
    
    func calculateFare(from: String, to: String, vehicleType: VehicleType) {
        // Mock fare calculation
        let baseFare: Double
        switch vehicleType {
        case .economy:
            baseFare = 12.0
        case .standard:
            baseFare = 18.0
        case .luxury:
            baseFare = 25.0
        }
        presenter?.didCalculateFare(baseFare)
    }
}

