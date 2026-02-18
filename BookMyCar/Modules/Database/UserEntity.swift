//
//  UserEntity.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftData
import Foundation

@Model
final class UserEntity {
    
    @Attribute(.unique) // Prevents duplicate email registration automatically.
    var email: String
    
    var username: String
    var password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
