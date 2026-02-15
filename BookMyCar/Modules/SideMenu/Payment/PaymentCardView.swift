//
//  PaymentCardView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

//import SwiftUI
//
//struct PaymentCardView: View {
//    let card: PaymentCardModel
//    let onDelete: () -> Void
//    let onSetDefault: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Card Type Badge
//            HStack {
//                Text(card.cardType.uppercased())
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(Color.orange)
//                    .cornerRadius(6)
//                
//                Spacer()
//                
//                if card.isDefault {
//                    Text("DEFAULT")
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(.green)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color.green.opacity(0.1))
//                        .cornerRadius(4)
//                }
//            }
//            
//            // Card Number
//            Text(card.maskedCardNumber)
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.black)
//                .tracking(2)
//            
//            // Cardholder & Expiry
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Name")
//                        .font(.system(size: 11))
//                        .foregroundColor(.gray)
//                    Text(card.cardHolderName)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.black)
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .trailing, spacing: 4) {
//                    Text("Valid")
//                        .font(.system(size: 11))
//                        .foregroundColor(.gray)
//                    Text(card.formattedExpiry)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.black)
//                }
//            }
//            
//            // Actions
//            HStack(spacing: 16) {
//                if !card.isDefault {
//                    Button {
//                        onSetDefault()
//                    } label: {
//                        Text("Set as Default")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(.blue)
//                    }
//                }
//                
//                Spacer()
//                
//                Button {
//                    onDelete()
//                } label: {
//                    Image(systemName: "trash")
//                        .font(.system(size: 16))
//                        .foregroundColor(.red)
//                }
//            }
//            .padding(.top, 8)
//        }
//        .padding(20)
//        .background(
//            LinearGradient(
//                colors: [
//                    Color.yellow.opacity(0.3),
//                    Color.orange.opacity(0.2)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//    }
//}
import SwiftUI

struct PaymentCardView: View {
    let card: PaymentCardModel
    let onDelete: () -> Void
    let onSetDefault: () -> Void
    let onEdit: () -> Void
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Card Type Badge
            HStack {
                Text(card.cardType.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .cornerRadius(6)
                
                Spacer()
                
                if card.isDefault {
                    Text("DEFAULT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            // Card Number
            Text(card.maskedCardNumber)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .tracking(2)
            
            // Cardholder & Expiry
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(card.cardHolderName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Valid")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(card.formattedExpiry)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            
            // Actions
            HStack(spacing: 16) {
                if !card.isDefault {
                    Button {
                        onSetDefault()
                    } label: {
                        Text("Set as Default")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                // Edit Button
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                
                // Delete Button
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    Color.yellow.opacity(0.3),
                    Color.orange.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .alert("Delete Card", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this card? This action cannot be undone.")
        }
    }
}
