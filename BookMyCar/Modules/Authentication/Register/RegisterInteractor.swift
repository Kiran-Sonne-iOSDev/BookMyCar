//
//  RegisterInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftData
import Foundation

protocol RegisterInteractorProtocol {
    func register(username: String,
                  email: String,
                  password: String,
                  context: ModelContext) -> Result<Bool, Error>
}

final class RegisterInteractor: RegisterInteractorProtocol {
    
    func register(username: String,
                  email: String,
                  password: String,
                  context: ModelContext) -> Result<Bool, Error> {
        
        let user = UserEntity(
            username: username,
            email: email,
            password: password
        )
        
        do {
            context.insert(user)
            try context.save()
            
            print("✅ SAVED TO DATABASE:", email)
            return .success(true)
            
        } catch {
            print("❌ DATABASE ERROR:", error.localizedDescription)
            return .failure(error)
        }
    }
}
