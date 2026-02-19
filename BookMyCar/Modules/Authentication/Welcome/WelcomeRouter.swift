//
//  WelcomeRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import Combine

final class WelcomeRouter: ObservableObject, WelcomeRouterProtocol {

    @Published var navigateToLogin: Bool = false
    @Published var navigateToRegister: Bool = false

    private let onLoginSuccess: () -> Void
    private let onRegisterSuccess: () -> Void

    init(
        onLoginSuccess: @escaping () -> Void,
        onRegisterSuccess: @escaping () -> Void
    ) {
        self.onLoginSuccess = onLoginSuccess
        self.onRegisterSuccess = onRegisterSuccess
    }

    static func createModule(
        onLoginSuccess: @escaping () -> Void,
        onRegisterSuccess: @escaping () -> Void
    ) -> some View {

        let router = WelcomeRouter(
            onLoginSuccess: onLoginSuccess,
            onRegisterSuccess: onRegisterSuccess
        )

        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter(
            interactor: interactor,
            router: router
        )

        return WelcomeView(presenter: presenter)
            .environmentObject(router)
    }

    func navigateToLoginScreen() {
        navigateToLogin = true
    }

    func navigateToRegisterScreen() {
        navigateToRegister = true
    }

    func loginSuccess() {
        onLoginSuccess()
    }

    func registerSuccess() {
        onRegisterSuccess()
    }
}
