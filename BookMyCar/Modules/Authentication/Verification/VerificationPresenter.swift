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
    @Published var isLoading: Bool = false


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
            isLoading = true
            // 3 seconds delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                self.router.navigateToHome()
            }
        } else {
            errorMessage = "Invalid OTP"
            otpDigits = Array(repeating: "", count: 4)
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
