//
//  UserSession.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData

@Observable
class UserSession {
    static let shared = UserSession()
    
    var currentUser: UserEntity?
    var isLoggedIn: Bool { currentUser != nil }
    
    private init() {}
    
    func login(user: UserEntity) {
        self.currentUser = user
        // Optionally save to UserDefaults for persistence
        UserDefaults.standard.set(user.email, forKey: "loggedInUserEmail")
    }
    
    func logout() {
        self.currentUser = nil
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
    }
    
    func loadSession(context: ModelContext) {
        guard let email = UserDefaults.standard.string(forKey: "loggedInUserEmail") else { return }
        
        let descriptor = FetchDescriptor<UserEntity>(
            predicate: #Predicate { $0.email == email }
        )
        
        if let user = try? context.fetch(descriptor).first {
            self.currentUser = user
        }
    }
}
 
