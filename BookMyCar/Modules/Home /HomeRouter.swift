//
//  HomeRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import Foundation
import SwiftUI

// MARK: - Home Router Protocol
protocol HomeRouterProtocol {
    func navigateToRideConfirmation(booking: RideBookingModel)
    func navigateToRideTracking()
}

// MARK: - Home Router
class HomeRouter: HomeRouterProtocol {
    
 
    // MARK: - Navigation Methods
    func navigateToRideConfirmation(booking: RideBookingModel) {
        print("🧭 Navigate to Ride Confirmation")
    }

    func navigateToRideTracking() {
        print("🧭 Navigate to Ride Tracking")
        // TODO: Implement navigation
    }
    
    // MARK: - Static Factory
    static func createModule() -> some View {
            let interactor = HomeInteractor()
            let router = HomeRouter()
            let service = LocationSearchService()
            let presenter = HomePresenter(
                interactor: interactor,
                router: router,
                locationSearchService: service
            )

            return HomeView(presenter: presenter)
        }

}

