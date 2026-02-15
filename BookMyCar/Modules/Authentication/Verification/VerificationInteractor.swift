//
//  VerificationInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import SwiftUI
final class VerificationInteractor: VerificationInteractorProtocol {

    weak var presenter: VerificationInteractorOutputProtocol?

    func validateOTP(_ otp: String) {
        // Mock validation (replace with API call)
        if otp == "1234" {
            presenter?.otpValidationSuccess()
        } else {
            presenter?.otpValidationFailure("Invalid verification code")
        }
    }
}
