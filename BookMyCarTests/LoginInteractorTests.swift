//
//  LoginInteractorTests.swift
//  BookMyCarTests
//
//  Created by Kiran Sonne on 19/02/26.
//

import Testing
import XCTest
import SwiftData
@testable import BookMyCar

final class LoginInteractorTests: XCTestCase {
    
    var interactor: LoginInteractor!
    var container: ModelContainer!
    var context: ModelContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create in-memory SwiftData container
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: UserEntity.self, configurations: config)
        context = ModelContext(container)
        
        interactor = LoginInteractor()
    }
    
    override func setUp() {
        super.setUp()
        
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: UserEntity.self, configurations: config)
            context = ModelContext(container)
            interactor = LoginInteractor()
        } catch {
            XCTFail("Failed to setup container: \(error)")
        }
    }

    
    func testLogin_UserNotFound() {
        
        let result = interactor.login(
            email: "test@mail.com",
            password: "123456",
            context: context
        )
        
        switch result {
        case .userNotFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected userNotFound")
        }
    }
    
    func testLogin_InvalidPassword() throws {
        
        // Insert test user
        let user = UserEntity(
            username: "test", email: "test@mail.com",
            password: "correctPassword"
        )
        
        context.insert(user)
        try context.save()
        
        let result = interactor.login(
            email: "test@mail.com",
            password: "wrongPassword",
            context: context
        )
        
        switch result {
        case .invalidPassword:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected invalidPassword")
        }
    }
    
    func testLogin_Success() throws {
        
        // Insert test user
        let user = UserEntity(
            username: "test", email: "test@mail.com",
            password: "123456"
        )
        
        context.insert(user)
        try context.save()
        
        let result = interactor.login(
            email: "test@mail.com",
            password: "",
            context: context
        )
        
        switch result {
        case .success(let returnedUser):
            XCTAssertEqual(returnedUser.email, "test@mail.com")
        default:
            XCTFail("Expected success")
        }
    }

}

