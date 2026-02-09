//
//  BookingDetailsBuilder.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI

enum BookingDetailsBuilder {
    
    static func build(bookingId: String) -> some View {
        let router = BookingDetailsRouter()
        let interactor = BookingDetailsInteractor()
        let presenter = BookingDetailsPresenter(
            interactor: interactor,
            router: router,
            bookingId: bookingId
        )
        interactor.presenter = presenter
        return BookingDetailsView(presenter: presenter)
    }
}
