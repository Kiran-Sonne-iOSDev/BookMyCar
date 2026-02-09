//
//  VerificationBuilder.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI

enum VerificationBuilder {

    static func build() -> some View {
        let router = VerificationRouter()
        let interactor = VerificationInteractor()
        let presenter = VerificationPresenter(
            interactor: interactor,
            router: router
        )
        interactor.presenter = presenter
        return VerificationView(presenter: presenter)
    }
}
 
