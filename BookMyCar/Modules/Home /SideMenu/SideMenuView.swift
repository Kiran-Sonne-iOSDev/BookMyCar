//
//  SideMenuView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//


import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedTab: SideMenuOption = .home
    
    var body: some View {
        ZStack {
            if isShowing {
                // Background overlay
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowing = false
                        }
                    }
                
                // Side menu content
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header with profile
                        sideMenuHeader()
                        
                        // Menu items
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(SideMenuOption.allCases, id: \.self) { option in
                                SideMenuRowView(
                                    option: option,
                                    isSelected: selectedTab == option
                                ) {
                                    selectedTab = option
                                    // Handle navigation
                                    handleMenuSelection(option)
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Logout button
                        logoutButton()
                    }
                    .frame(width: 280)
                    .background(Color.white)
                    .transition(.move(edge: .leading))
                    
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
    
    // MARK: - Header
    private func sideMenuHeader() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Orange gradient background
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 180)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Profile image with star rating
                    HStack(alignment: .top) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 65, height: 65)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        // Star rating
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 18))
                            Text("5")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8)
                    }
                    
                    // User name
                    Text("Your name")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Logout Button
    private func logoutButton() -> some View {
        Button(action: {
            // Handle logout
            print("Logout tapped")
        }) {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                
                Text("Logout")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(Color.white)
        .padding(.bottom, 40)
    }
    
    // MARK: - Handle Menu Selection
    private func handleMenuSelection(_ option: SideMenuOption) {
        print("Selected: \(option.title)")
        // Close menu after selection
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                isShowing = false
            }
        }
    }
}

// MARK: - Side Menu Option
enum SideMenuOption: CaseIterable {
    case home
    case orderList
    case cards
    case chatWithUs
    
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .orderList:
            return "Ordered Lists"
        case .cards:
            return "Add Cards"
        case .chatWithUs:
            return "Chat with us"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .cards, .chatWithUs:
            return "list.bullet.rectangle"
        case .orderList:
            return "arrow.down.circle"
        }
    }
}

// MARK: - Side Menu Row
struct SideMenuRowView: View {
    let option: SideMenuOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: option.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .orange : .gray)
                    .frame(width: 25)
                
                Text(option.title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(isSelected ? Color.orange.opacity(0.1) : Color.clear)
        }
    }
}

// MARK: - Preview
#Preview {
    SideMenuView(isShowing: .constant(true))
}
