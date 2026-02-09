//
//  Home.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import SwiftUI
struct Home: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.2)
                .ignoresSafeArea()
            
            Text("Welcome to Home Screen! 🎉")
                .font(.title)
                .bold()
        }
    }
}
