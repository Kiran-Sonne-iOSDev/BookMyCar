//
//  WelcomeView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject var presenter: WelcomePresenter
    @EnvironmentObject var router: WelcomeRouter
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [
                        Color(hex: "FFD700"),
                        Color(hex: "FFA500")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // App Icon/Logo Area
                    VStack(spacing: 16) {
                        Image(systemName: "car.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 10)
                        
                        Text("BookMyCar")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your ride, your way")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 80)
                    
                    Spacer()
                    
                    // Buttons Section
                    VStack(spacing: 16) {
                        // Login Button
                        Button(action: {
                            presenter.loginTapped()
                        }) {
                            Text("Login")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "FFA500"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(28)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        
                        // Register Button
                        Button(action: {
                            presenter.registerTapped()
                        }) {
                            Text("Register")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
            .navigationDestination(isPresented: $router.navigateToLogin) {
                LoginRouter.createModule(
                    onLoginSuccess: {
                        router.loginSuccess()
                    }
                )
            }
            .navigationDestination(isPresented: $router.navigateToRegister) {
                RegisterRouter.createModule(
                    onRegisterSuccess: {
                        router.registerSuccess()
                    }
                )
            }
        }
    }
}
