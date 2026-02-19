//
//  BookMyCarApp.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import SwiftUI
import SwiftData
@main
struct BookMyCarApp: App {
    
    @State private var appState: AppState = .onboarding
    @State private var session = UserSession.shared
  
    var body: some Scene {
        WindowGroup {
            
            switch appState {
                
            case .onboarding:
                OnboardingRouter.createModule {
                    appState = .welcome
                }
            case .welcome:
                WelcomeRouter.createModule(
                    onLoginSuccess: {
                         appState = .verification
                    },
                    onRegisterSuccess: {
                         appState = .verification
                    }
                )
                
            case .verification:
                VerificationBuilder.build {
                      appState = .home
                }
                
            case .home:
                HomeRouter.createModule()
                    .environment(\.appStateBinding, $appState) 
            }
        }
        .modelContainer(for: [UserEntity.self, RideBookingModel.self, PaymentCardModel.self])
    }
}
enum AppState {
    case onboarding
    case welcome
    case verification
    case home
}
 
private struct AppStateKey: EnvironmentKey {
    static let defaultValue: Binding<AppState> = .constant(.home)
}

extension EnvironmentValues {
    var appStateBinding: Binding<AppState> {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
    }
}
