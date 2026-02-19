//
//  LoginRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//
import SwiftUI
import Combine
final class LoginRouter: ObservableObject {

    private let onLoginSuccess: () -> Void
    @Published var navigateToRegister = false


    init(onLoginSuccess: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
    }

    static func createModule(
        onLoginSuccess: @escaping () -> Void
    ) -> some View {

        let router = LoginRouter(onLoginSuccess: onLoginSuccess)
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(
            interactor: interactor,
            router: router
        )

        return LoginView(presenter: presenter).environmentObject(router)
    }

    func navigateToVerification() {
        onLoginSuccess()
    }
    func navigateToRegisterScreen() {
        navigateToRegister = true
    }

}

