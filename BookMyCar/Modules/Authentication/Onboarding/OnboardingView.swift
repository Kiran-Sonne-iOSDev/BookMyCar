//
//  OnboardingView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import SwiftUI

struct OnboardingView: View {
    // The presenter will control this view
    @ObservedObject var presenter: OnboardingPresenter
    
    var body: some View {
        ZStack {
            // Background color
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // 1. IMAGE
                Image(systemName: "car.fill")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .foregroundColor(.yellow)
                
                // 2. TITLE
                Text(presenter.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                // 3. DESCRIPTION
                Text(presenter.description)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // 4. GET STARTED BUTTON
                Button(action: {
                    // When button is pressed, tell the presenter
                    presenter.getStartedButtonTapped()
                }) {
                    Text("GET STARTED")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.yellow)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // When view appears, tell the presenter
            presenter.viewAppeared()
        }
    }
}
