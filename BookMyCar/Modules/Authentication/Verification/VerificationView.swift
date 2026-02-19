//
//  VerificationView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation
import SwiftUI

struct VerificationView: View {

    @StateObject var presenter: VerificationPresenter
    @FocusState private var focusedIndex: Int?
     
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
            
            VStack(spacing: 40) {
                Spacer()
                
                // Header Icon
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 10)
                
                // Title & Description
                VStack(spacing: 12) {
                    Text(presenter.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(presenter.description)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // OTP Input Card
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { index in
                            TextField("", text: $presenter.otpDigits[index])
                                .keyboardType(.numberPad)
                                .frame(width: 60, height: 70)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(hex: "FFA500"))
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.1), radius: 8)
                                .focused($focusedIndex, equals: index)
                                .onChange(of: presenter.otpDigits[index]) { newValue in
                                    if newValue.count == 1 {
                                        focusedIndex = index < 3 ? index + 1 : nil
                                    }
                                }
                        }
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
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding(32)
                .background(Color.white.opacity(0.2))
                .cornerRadius(24)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Verify Button
                Button(action: {
                    presenter.verifyOTP()
                }) {
                    Text("Verify OTP")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "FFA500"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
            .onAppear {
                presenter.onViewAppear()
                focusedIndex = 0
            }
            .onChange(of: presenter.errorMessage) { _ in
                if presenter.errorMessage != nil {
                    focusedIndex = 0
                }
            }

            // 🔥 Loader Overlay
            if presenter.isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Verifying")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(40)
                .background(Color.yellow.opacity(0.8))
                .cornerRadius(12)
            }
        }
    }
}
