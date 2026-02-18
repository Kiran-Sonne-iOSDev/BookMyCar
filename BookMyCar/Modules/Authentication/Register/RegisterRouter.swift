//
//  RegisterRouter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import Combine

final class RegisterRouter: ObservableObject {

    private let onRegisterSuccess: () -> Void

    init(onRegisterSuccess: @escaping () -> Void) {
        self.onRegisterSuccess = onRegisterSuccess
    }

    static func createModule(
        onRegisterSuccess: @escaping () -> Void
    ) -> some View {

        let router = RegisterRouter(
            onRegisterSuccess: onRegisterSuccess
        )

        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter(
            interactor: interactor,
            router: router
        )

        return RegisterView(presenter: presenter)
    }

    func navigateToVerification() {
        onRegisterSuccess()
    }
}
