//
//  HomeEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

 import Foundation

enum VehicleType: String, CaseIterable {
    case economy = "Economy"
    case standard = "Standard"
    case luxury = "Luxury"
}

struct Vehicle: Identifiable {
    let id: String
    let type: VehicleType
    let latitude: Double
    let longitude: Double
    let estimatedTime: String
    let fare: String
}

struct LocationPoint {
    let latitude: Double
    let longitude: Double
}
