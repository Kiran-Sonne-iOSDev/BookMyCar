//
//  VerificationRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import SwiftUI
final class VerificationRouter: VerificationRouterProtocol {
    
    private let onNavigateToHome: () -> Void
    
    init(onNavigateToHome: @escaping () -> Void) {
        self.onNavigateToHome = onNavigateToHome
    }
    
    func navigateToHome() {
        onNavigateToHome()
    }
    
    // MARK: - Factory
    static func build(onNavigateToHome: @escaping () -> Void) -> some View {
        
        let router = VerificationRouter(onNavigateToHome: onNavigateToHome)
        let interactor = VerificationInteractor()
        let presenter = VerificationPresenter(interactor: interactor,
                                              router: router)
        
        return VerificationView(presenter: presenter)
    }
}
