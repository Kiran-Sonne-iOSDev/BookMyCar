//
//  VerificationContracts.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
protocol VerificationViewProtocol: AnyObject {
    func showError(_ message: String)
}

protocol VerificationPresenterProtocol {
    func onViewAppear()
    func verifyOTP()
}

protocol VerificationInteractorProtocol {
    func validateOTP(_ otp: String)
}

protocol VerificationInteractorOutputProtocol: AnyObject {
    func otpValidationSuccess()
    func otpValidationFailure(_ error: String)
}

protocol VerificationRouterProtocol {
    func navigateToHome()
}
