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
    @State private var isOnboardingComplete = false
    var body: some Scene {
        WindowGroup {
            if isOnboardingComplete {
                // Home screen after onboarding
                Home()
            }else {
                // Show onboarding
                OnboardingRouter.createModule {
                    isOnboardingComplete = true
                }
            }
        }
       // .modelContainer(sharedModelContainer)
    }
}
