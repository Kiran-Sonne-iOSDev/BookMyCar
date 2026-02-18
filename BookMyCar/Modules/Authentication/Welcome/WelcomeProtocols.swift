//
//  WelcomeProtocols.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI

protocol WelcomeViewProtocol: AnyObject {
}

protocol WelcomePresenterProtocol: AnyObject {
    func loginTapped()
    func registerTapped()
}

protocol WelcomeInteractorProtocol {
}

protocol WelcomeRouterProtocol {
    func navigateToLoginScreen()
    func navigateToRegisterScreen()
}

