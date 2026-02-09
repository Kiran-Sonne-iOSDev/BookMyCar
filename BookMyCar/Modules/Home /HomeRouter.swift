//
//  HomeRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI
final class HomeRouter: HomeRouterProtocol {
    
    func navigateToBookingDetails() {
        let bookingDetailsView = BookingDetailsBuilder.build(bookingId: "BK\(Int.random(in: 100000...999999))")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let hostingController = UIHostingController(rootView: bookingDetailsView)
            
            // If you're using NavigationView, push it
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.pushViewController(hostingController, animated: true)
            } else {
                // Otherwise, present it
                window.rootViewController?.present(hostingController, animated: true)
            }
        }
    }
}
