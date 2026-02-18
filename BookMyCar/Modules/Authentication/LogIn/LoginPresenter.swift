//
//  LoginPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftData
import Combine
import Foundation

final class LoginPresenter: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isSuccess = false
    @Published var showRegisterButton = false
    @Published var isLoading: Bool = false
    
    var interactor: LoginInteractorProtocol?
    var modelContext: ModelContext?
    var router: LoginRouter?
    
    // ✅ Store cancellables
    private var cancellables = Set<AnyCancellable>()

    init(interactor: LoginInteractorProtocol,
         router: LoginRouter) {
        self.interactor = interactor
        self.router = router
        
        // ✅ Clear error when user types in email or password
        setupErrorClearingObservers()
    }
    
    // ✅ NEW: Setup observers to clear error message
    private func setupErrorClearingObservers() {
        // Clear error when email changes
        $email
            .dropFirst() // Skip initial value
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
        
        // Clear error when password changes
        $password
            .dropFirst() // Skip initial value
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func loginTapped() {
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Email is required"
            return
        }
        
        guard isValidEmail(trimmedEmail) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard !trimmedPassword.isEmpty else {
            errorMessage = "Password is required"
            return
        }
        
        guard let context = modelContext else { return }
        
        let result = interactor?.login(
            email: trimmedEmail,
            password: trimmedPassword,
            context: context
        )
        
        switch result {
        case .success(let user):
            errorMessage = nil
            showRegisterButton = false
            isSuccess = true
            isLoading = true
            
            UserSession.shared.login(user: user)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                self.router?.navigateToVerification()
            }
            
        case .userNotFound:
            errorMessage = "Account not found. Please register first."
            showRegisterButton = true
            
        case .invalidPassword:
            showRegisterButton = false
            errorMessage = "Incorrect password. Please try again."
            
        case .none:
            errorMessage = "Something went wrong."
        }
    }
}
