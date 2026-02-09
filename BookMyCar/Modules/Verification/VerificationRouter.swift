//
//  VerificationRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

 import SwiftUI

final class VerificationRouter: VerificationRouterProtocol {

    func navigateToHome() {
        let homeView = HomeBuilder.build()
        
        // Update the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: homeView)
            window.makeKeyAndVisible()
        }
    }
}
