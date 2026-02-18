//
//  PaymentSelectionView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 15/02/26.
//

import Foundation
import SwiftUI
import SwiftData

struct PaymentSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var savedCards: [PaymentCardModel]
    
    let booking: RideBookingModel
    let onPaymentSelected: (PaymentCardModel) -> Void
    let onNonCardPayment: ((RideBookingModel) -> Void)?  // ✅ Add this callback
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "FF9800"),
                        Color(hex: "FFC107")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    header
                    
                    // Content
                    if savedCards.isEmpty {
                        emptyState
                    } else {
                        paymentMethodsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text("Select Payment")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Invisible button for balance
                Color.clear
                    .frame(width: 44, height: 44)
            }
            
            // Ride Summary
            VStack(alignment: .leading, spacing: 4) {
                Text("Ride Summary")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                
                HStack {
                    Text(booking.carTypeName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(booking.estimatedPrice)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    // MARK: - Payment Methods List
    private var paymentMethodsList: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // UPI Option
                    PaymentOptionCard(
                        icon: "indianrupeesign.circle.fill",
                        title: "UPI Payment",
                        subtitle: "Pay using UPI apps",
                        color: .purple
                    ) {
                        handleUPIPayment()
                    }
                    
                    // COD Option
                    PaymentOptionCard(
                        icon: "banknote.fill",
                        title: "Cash on Delivery",
                        subtitle: "Pay with cash when you arrive",
                        color: .green
                    ) {
                        handleCODPayment()
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)
                    
                    // Saved Cards Section
                    if !sortedCards.isEmpty {
                        Text("Saved Cards")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                        
                        ForEach(sortedCards) { card in
                            PaymentMethodCard(
                                card: card,
                                onSelect: {
                                    onPaymentSelected(card)
                                    dismiss()
                                }
                            )
                        }
                    }
                    
                    // Add New Card Button
                    NavigationLink {
                        PaymentView()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                            
                            Text("Add New Card")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }

    // MARK: - Payment Handlers
    private func handleUPIPayment() {
        booking.paymentMethod = "UPI Payment"
        completeBookingAndNavigate()
    }

    private func handleCODPayment() {
        booking.paymentMethod = "Cash on Delivery"
        completeBookingAndNavigate()
    }
    
    private func completeBookingAndNavigate() {
        modelContext.insert(booking)
        
        do {
            try modelContext.save()
            print("✅ Ride booked successfully")
            dismiss()
            
            // Trigger navigation through callback
            onNonCardPayment?(booking)
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.7))
            
            Text("No payment methods")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Add a card to continue booking")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
            
            NavigationLink {
                PaymentView()
            } label: {
                Text("Add Card")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helpers
    private var sortedCards: [PaymentCardModel] {
        savedCards.sorted { card1, card2 in
            if card1.isDefault != card2.isDefault {
                return card1.isDefault
            }
            return card1.createdDate > card2.createdDate
        }
    }
}

// MARK: - Payment Method Card
struct PaymentMethodCard: View {
    let card: PaymentCardModel
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
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
                
                Text(card.maskedCardNumber)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .tracking(2)
                
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
        }
    }
}

// MARK: - Payment Option Card
struct PaymentOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(12)
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
    }
}
