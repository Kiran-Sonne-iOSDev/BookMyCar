//
//  VerificationBuilder.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI
enum VerificationBuilder {

    static func build(onNavigateToHome: @escaping () -> Void) -> some View {
        
        let router = VerificationRouter(onNavigateToHome: onNavigateToHome)
        let interactor = VerificationInteractor()
        let presenter = VerificationPresenter(
            interactor: interactor,
            router: router
        )
        
        interactor.presenter = presenter
        
        return VerificationView(presenter: presenter)
    }
}

