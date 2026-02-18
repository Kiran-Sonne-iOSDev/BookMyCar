//
//  HomeView + Extension.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 15/02/26.
//

import SwiftUI
extension HomeView {
    
    // MARK: - Enhanced Car Type Card
    struct EnhancedCarTypeCard: View {
        let carType: CarTypeEntity
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Group {
                        if carType.isSystemIcon {
                            Image(systemName: carType.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image(carType.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .foregroundColor(isSelected ? .black : .gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(carType.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(isSelected ? .black : .gray)
                            
                            HStack(spacing: 2) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 8))
                                Text("\(carType.capacity)")
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.6))
                            .cornerRadius(8)
                        }
                        
                        Text("2 mins away")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(carType.priceRange)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? Color(hex: "FFD700") : .black)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color(hex: "FFF9E6") : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? Color(hex: "FFD700") : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                        )
                )
                .shadow(color: isSelected ? Color(hex: "FFD700").opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: 2)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    struct CarTypeCard: View {
        let carType: CarTypeEntity
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 12) {
                    Group {
                        if carType.isSystemIcon {
                            Image(systemName: carType.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image(carType.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .black : .gray)
                    
                    Text(carType.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isSelected ? .black : .gray)
                    
                    Text(carType.priceRange)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? Color(hex: "FFD700") : .gray)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                        Text("\(carType.capacity)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(isSelected ? .black.opacity(0.7) : .gray)
                }
                .frame(width: 100)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color(hex: "FFF9E6") : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color(hex: "FFD700") : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }

    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }

    struct RideDetailItem: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "0066FF"))
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
    }

}
