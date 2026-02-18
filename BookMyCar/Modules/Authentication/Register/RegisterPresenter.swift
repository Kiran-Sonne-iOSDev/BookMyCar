//
//  RegisterPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Combine
import SwiftData
import Foundation

final class RegisterPresenter: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var isSuccess = false
    @Published var navigateToVerification = false

    var router: RegisterRouter?
    var interactor: RegisterInteractorProtocol?
    var modelContext: ModelContext?
    
    // ✅ Store cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: RegisterInteractorProtocol,
         router: RegisterRouter) {
        self.interactor = interactor
        self.router = router
        
        // ✅ Clear error when user types in any field
        setupErrorClearingObservers()
    }
    
    // ✅ NEW: Setup observers to clear error message
    private func setupErrorClearingObservers() {
        // Clear error when username changes
        $username
            .dropFirst()
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
        
        // Clear error when email changes
        $email
            .dropFirst()
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
        
        // Clear error when password changes
        $password
            .dropFirst()
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
        
        // Clear error when confirm password changes
        $confirmPassword
            .dropFirst()
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func registerTapped() {
        
        // Trim whitespace
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1️⃣ Empty field validation
        guard !trimmedUsername.isEmpty else {
            errorMessage = "Username is required"
            return
        }
        
        // ✅ Username validation: only letters and spaces
        guard isValidUsername(trimmedUsername) else {
            errorMessage = "Username must contain only letters and spaces"
            return
        }
        
        guard trimmedUsername.count >= 3 else {
            errorMessage = "Username must be at least 3 characters"
            return
        }
        
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
        
        guard trimmedPassword.count >= 5 else {
            errorMessage = "Password must be at least 5 characters"
            return
        }
        
        guard trimmedPassword == trimmedConfirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard let context = modelContext else { return }
        guard let interactor = interactor else { return }
        
        let result = interactor.register(
            username: trimmedUsername,
            email: trimmedEmail,
            password: trimmedPassword,
            context: context
        )
        
        switch result {
        case .success:
            errorMessage = nil
            isSuccess = true
            
        case .failure(let error):
            print("SAVE FAILED:", error.localizedDescription)
            errorMessage = "User already exists"
        }
    }
    
    // ✅ NEW: Username validation (only letters and spaces)
    private func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z ]+$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    
    // ✅ Email validation helper
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
