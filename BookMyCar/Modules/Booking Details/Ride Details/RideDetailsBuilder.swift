//
//  RideDetailsBuilder.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//


import Foundation
import SwiftUI

enum RideDetailsBuilder {
    
    static func build(rideId: String) -> some View {
        let router = RideDetailsRouter()
        let interactor = RideDetailsInteractor()
        let presenter = RideDetailsPresenter(
            interactor: interactor,
            router: router,
            rideId: rideId
        )
        interactor.presenter = presenter
        return RideDetailsView(presenter: presenter)
    }
}
