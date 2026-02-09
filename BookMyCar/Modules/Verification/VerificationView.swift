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
        VStack(spacing: 20) {

            Spacer()

            Text(presenter.title)
                .font(.title)
                .fontWeight(.bold)

            Text(presenter.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // OTP Fields
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $presenter.otpDigits[index])
                        .keyboardType(.numberPad)
                        .frame(width: 50, height: 55)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: presenter.otpDigits[index]) { newValue in
                            if newValue.count == 1 {
                                focusedIndex = index < 3 ? index + 1 : nil
                            }
                        }
                }
            }

            if let error = presenter.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()

            Button(action: {
                presenter.verifyOTP()
            }) {
                Text("Verify OTP")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

        }
        .padding()
        .onAppear {
            presenter.onViewAppear()
            focusedIndex = 0
        }
    }
}
