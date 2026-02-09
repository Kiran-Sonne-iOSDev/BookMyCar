//
//  OnboardingRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import Foundation
import SwiftUI

class OnboardingRouter {
    // Callback when user completes onboarding
    var onComplete: (() -> Void)?
    
    // MARK: - Create the Module
    // This builds all VIPER components and connects them
    static func createModule(onComplete: @escaping () -> Void) -> some View {
        // 1. Create all components
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()
        
        // 2. Connect them together
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.onComplete = onComplete
        
        // 3. Create and return the view
        let view = OnboardingView(presenter: presenter)
        return view
    }
    
    // Navigate to home screen
    func navigateToHome() {
        let verificationView = VerificationBuilder.build()
                UIApplication.shared.windows.first?.rootViewController =
                    UIHostingController(rootView: verificationView)
    }
}
