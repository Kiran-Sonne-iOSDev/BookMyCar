//
//  VerificationPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Combine
import SwiftUI

final class VerificationPresenter: ObservableObject {

    // MARK: - UI State
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var otpDigits: [String] = Array(repeating: "", count: 4)
    @Published var errorMessage: String?

    private let interactor: VerificationInteractorProtocol
    private let router: VerificationRouterProtocol

    init(interactor: VerificationInteractorProtocol,
         router: VerificationRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presenter Protocol
extension VerificationPresenter: VerificationPresenterProtocol {

    func onViewAppear() {
        let model = OTPModel(
            title: "Verification Code",
            description: "Enter the 4-digit code sent to your mobile number",
            otpLength: 4
        )
        title = model.title
        description = model.description
    }
    
    func verifyOTP() {
        let otp = otpDigits.joined()
        if otp == "1234" {
            router.navigateToHome()
        } else {
            errorMessage = "Invalid OTP"
        }
    }


}

// MARK: - Interactor Output
extension VerificationPresenter: VerificationInteractorOutputProtocol {

    func otpValidationSuccess() {
        router.navigateToHome()
    }

    func otpValidationFailure(_ error: String) {
        errorMessage = error
    }
}
