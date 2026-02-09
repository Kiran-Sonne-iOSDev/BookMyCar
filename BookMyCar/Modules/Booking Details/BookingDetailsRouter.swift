//
//  BookingDetailsRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//


// BookingDetailsRouter.swift
import SwiftUI

final class BookingDetailsRouter: BookingDetailsRouterProtocol {
    
    func navigateToRideDetails(rideId: String) {
        let rideDetailsView = RideDetailsBuilder.build(rideId: rideId)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let hostingController = UIHostingController(rootView: rideDetailsView)
            
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.pushViewController(hostingController, animated: true)
            }
        }
    }
    
    func navigateBack() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let navigationController = window.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(cleanNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
