//
//  LoginInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftData
import Foundation
enum LoginResult {
    case success(UserEntity)
    case userNotFound
    case invalidPassword
}
protocol LoginInteractorProtocol {
    func login(email: String,
               password: String,
               context: ModelContext) -> LoginResult
}
final class LoginInteractor: LoginInteractorProtocol {
    
    func login(email: String,
               password: String,
               context: ModelContext) -> LoginResult {
        
        let descriptor = FetchDescriptor<UserEntity>(
            predicate: #Predicate { $0.email == email }
        )
        
        do {
            let users = try context.fetch(descriptor)
            
            guard let user = users.first else {
                return .userNotFound
            }
            
            if user.password == password {
                return .success(user)
            } else {
                return .invalidPassword
            }
            
        } catch {
            return .userNotFound
        }
    }
}

