//
//  SideMenuView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import SwiftUI
struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var navigateToMyRides = false
    @State private var navigateToPayment = false
    @State private var navigateToFavorites = false
    @State private var navigateToSettings = false
    
    private var currentUser: UserEntity? {
        UserSession.shared.currentUser
    }
    
    var body: some View {
        ZStack {
            if isShowing {
                // Dimmed background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                // Side menu
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentUser?.username ?? "Guest User")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text(currentUser?.email ?? "guest@example.com")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 60)
                        .padding(.bottom, 30)
                        
                        Divider()
                        
                        // Menu Items
                        VStack(spacing: 0) {
                            MenuItemView(icon: "house.fill", title: "Home") {
                                isShowing = false
                            }
                            
                            MenuItemView(icon: "clock.fill", title: "My Rides") {
                                navigateToMyRides = true
                                isShowing = false
                            }
                            
                            MenuItemView(icon: "wallet.pass.fill", title: "Payment") {
                                navigateToPayment = true
                                    isShowing = false
                            }
                            
                            MenuItemView(icon: "star.fill", title: "Favorites") {
                                navigateToFavorites = true
                                   isShowing = false
                            }
                            
                            MenuItemView(icon: "gearshape.fill", title: "Settings") {
                                navigateToSettings = true
                                   isShowing = false
                            }
                            
                            MenuItemView(icon: "questionmark.circle.fill", title: "Help") {
                                // Handle Help tap
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Logout
                        Button(action: {
                            UserSession.shared.logout()
                            isShowing = false
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 20))
                                Text("Logout")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.red)
                            .padding()
                        }
                    }
                    .frame(width: 280)
                    .background(Color.white)
                    .transition(.move(edge: .leading))
                    
                    Spacer()
                }
            }
            
            // ✅ Navigation to My Rides
            NavigationLink(
                destination: MyRidesView(),
                isActive: $navigateToMyRides
            ) {
                EmptyView()
            }
            NavigationLink(
                destination: PaymentView(),
                isActive: $navigateToPayment
            ) {
                EmptyView()
            }
            NavigationLink(
                destination: FavoritesView(),
                isActive: $navigateToFavorites
            ) {
                EmptyView()
            }
            NavigationLink(
                destination: ContentView(),
                isActive: $navigateToSettings
            ) {
                EmptyView()
            }
            
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowing)
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}
