//
//  RegisterView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var presenter: RegisterPresenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                // ✅ Back Button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text("Create Account")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Sign up to get started")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 20)
                        
                        // Form Card
                        VStack(spacing: 20) {
                            // Username Field
                            // Username Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Username")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter your username", text: $presenter.username)
                                        .autocapitalization(.none)
                                        .onChange(of: presenter.username) { newValue in
                                            // ✅ Filter out numbers and special characters in real-time
                                            presenter.username = newValue.filter { $0.isLetter || $0.isWhitespace }
                                        }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                            
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
                                        .textInputAutocapitalization(.never)
                                        .onChange(of: presenter.email) { newValue in
                                            // ✅ Convert to lowercase in real-time
                                            presenter.email = newValue.lowercased()
                                        }
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
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.gray)
                                    
                                    SecureField("Confirm your password", text: $presenter.confirmPassword)
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
                            
                            // Register Button
                            Button("Register") {
                                presenter.modelContext = modelContext
                                presenter.registerTapped()
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
                        }
                        .padding(24)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.1), radius: 20)
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Success", isPresented: $presenter.isSuccess) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("User registered successfully")
        }
    }
}
