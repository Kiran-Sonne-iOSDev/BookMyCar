//
//  HomeContracts.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI

protocol HomeViewProtocol: AnyObject {
    func showError(_ message: String)
}

protocol HomePresenterProtocol {
    func onViewAppear()
    func selectVehicleType(_ type: VehicleType)
    func bookRide()
}

protocol HomeInteractorProtocol {
    func fetchNearbyVehicles()
    func calculateFare(from: String, to: String, vehicleType: VehicleType)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchVehicles(_ vehicles: [Vehicle])
    func didCalculateFare(_ fare: Double)
    func didFailWithError(_ error: String)
}

protocol HomeRouterProtocol {
    func navigateToBookingDetails()
}

enum HomeBuilder {
    
    static func build() -> some View {
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(
            interactor: interactor,
            router: router
        )
        interactor.presenter = presenter
        return HomeView(presenter: presenter)
    }
}
