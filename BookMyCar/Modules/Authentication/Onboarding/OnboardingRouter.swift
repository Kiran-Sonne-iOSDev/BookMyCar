//
//  OnboardingRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import Foundation
import SwiftUI
import UIKit

class OnboardingRouter: VerificationRouterProtocol {
    // Callback when user completes onboarding
    var onComplete: (() -> Void)?
    
    // MARK: - Create the Module
    
    static func createModule(onComplete: @escaping () -> Void) -> some View {

        let interactor = OnboardingInteractor()
        let router = OnboardingRouter()
        let presenter = OnboardingPresenter()

        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        router.onComplete = onComplete

        return OnboardingView(presenter: presenter)
    }

    func navigateToVerification() {
        onComplete?()
    }
    
    // Navigate to home screen
    func navigateToHome() {
        func navigateToHome() {
            onComplete?()
        }

    }
}
