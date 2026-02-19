//
//  LoginView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var presenter: LoginPresenter
    @EnvironmentObject var router: LoginRouter
    
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Login to continue")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 60)
                        
                        // Form Card
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter your email", text: $presenter.email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.gray)
                                    
                                    SecureField("Enter your password", text: $presenter.password)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                            
                            // Error Message
                            if let error = presenter.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(error)
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Login Button
                            Button("Login") {
                                presenter.modelContext = modelContext
                                presenter.loginTapped()
                            }
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FFA500"), Color(hex: "FF8C00")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: Color(hex: "FFA500").opacity(0.4), radius: 10, x: 0, y: 5)
                            .padding(.top, 10)
                            
                            // Register Button
                            if presenter.showRegisterButton {
                                Button("Register Now") {
                                    router.navigateToRegisterScreen()
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "FF8C00"))
                            }
                        }
                        .padding(24)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.1), radius: 20)
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // 🔥 Loader Overlay
                if presenter.isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)

                        Text("Signing")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding(40)
                    .background(Color.yellow.opacity(0.8))
                    .cornerRadius(12)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $router.navigateToRegister) {
                RegisterRouter.createModule {
                }
            }
        }
    }
}
