//
//  File.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import Combine

final class WelcomePresenter: ObservableObject, WelcomePresenterProtocol {
    
    private let interactor: WelcomeInteractorProtocol
    private let router: WelcomeRouterProtocol
    
    init(interactor: WelcomeInteractorProtocol,
         router: WelcomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loginTapped() {
        router.navigateToLoginScreen()
    }
    
    func registerTapped() {
        router.navigateToRegisterScreen()
    }
}

