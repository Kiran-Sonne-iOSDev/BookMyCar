//
//  RideDetailsRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import SwiftUI

final class RideDetailsRouter: RideDetailsRouterProtocol {
    
    func navigateToHome() {
        let homeView = HomeBuilder.build()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: homeView)
            window.makeKeyAndVisible()
        }
    }
}
