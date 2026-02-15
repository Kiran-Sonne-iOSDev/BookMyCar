//
//  PaymentPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData
import Combine

class PaymentPresenter: ObservableObject {
    @Published var savedCards: [PaymentCardModel] = []
    @Published var showAddCardSheet = false
    @Published var showEditCardSheet = false
    
    // Add/Edit Card Form Fields
    @Published var cardHolderName = ""
    @Published var cardNumber = ""
    @Published var expiryMonth = ""
    @Published var expiryYear = ""
    @Published var cvv = ""
    @Published var cardType = "Credit"
    
    @Published var errorMessage: String?
    
    var modelContext: ModelContext?
    var editingCard: PaymentCardModel?
    private func isValidCardholderName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    // MARK: - Fetch Cards
    func fetchCards() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<PaymentCardModel>(
            sortBy: [
                SortDescriptor(\.createdDate, order: .reverse)
            ]
        )
        
        do {
            let allCards = try context.fetch(descriptor)
            
            // Manual sorting: default cards first, then by creation date
            savedCards = allCards.sorted { card1, card2 in
                if card1.isDefault != card2.isDefault {
                    return card1.isDefault
                }
                return card1.createdDate > card2.createdDate
            }
        } catch {
            print("❌ Failed to fetch cards: \(error)")
        }
    }
    
    // MARK: - Add Card
    func addCard() {
        guard validateCard() else { return }
        guard let context = modelContext else { return }
        
        let isFirstCard = savedCards.isEmpty
        
        let newCard = PaymentCardModel(
            cardHolderName: cardHolderName,
            cardNumber: cardNumber.replacingOccurrences(of: " ", with: ""),
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvv: cvv,
            cardType: cardType,
            isDefault: isFirstCard
        )
        
        context.insert(newCard)
        
        do {
            try context.save()
            print("✅ Card added successfully")
            resetForm()
            showAddCardSheet = false
            fetchCards()
        } catch {
            errorMessage = "Failed to save card"
            print("❌ Failed to save card: \(error)")
        }
    }
    
    // MARK: - Prepare Edit
    func prepareEdit(card: PaymentCardModel) {
        editingCard = card
        cardHolderName = card.cardHolderName
        
        // Format card number with spaces
        let cleaned = card.cardNumber
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        cardNumber = formatted
        
        expiryMonth = card.expiryMonth
        expiryYear = card.expiryYear
        cvv = card.cvv
        cardType = card.cardType
        showEditCardSheet = true
    }
    
    // MARK: - Update Card
    func updateCard() {
        guard validateCard() else { return }
        guard let card = editingCard else { return }
        guard let context = modelContext else { return }
        
        card.cardHolderName = cardHolderName
        card.cardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        card.expiryMonth = expiryMonth
        card.expiryYear = expiryYear
        card.cvv = cvv
        card.cardType = cardType
        
        do {
            try context.save()
            print("✅ Card updated successfully")
            resetForm()
            showEditCardSheet = false
            editingCard = nil
            fetchCards()
        } catch {
            errorMessage = "Failed to update card"
            print("❌ Failed to update card: \(error)")
        }
    }
    
    // MARK: - Delete Card
    func deleteCard(_ card: PaymentCardModel) {
        guard let context = modelContext else { return }
        
        context.delete(card)
        
        do {
            try context.save()
            fetchCards()
        } catch {
            print("❌ Failed to delete card: \(error)")
        }
    }
    
    // MARK: - Set Default Card
    func setDefaultCard(_ card: PaymentCardModel) {
        guard let context = modelContext else { return }
        
        for savedCard in savedCards {
            savedCard.isDefault = false
        }
        
        card.isDefault = true
        
        do {
            try context.save()
            fetchCards()
        } catch {
            print("❌ Failed to set default card: \(error)")
        }
    }
    
    // MARK: - Validation
    private func validateCard() -> Bool {
        errorMessage = nil
        
        guard !cardHolderName.isEmpty else {
            errorMessage = "Please enter cardholder name"
            return false
        }
        guard isValidCardholderName(cardHolderName) else {
                errorMessage = "Cardholder name must contain only letters"
                return false
            }
        
        let cleanedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        guard cleanedNumber.count == 16 else {
            errorMessage = "Card number must be 16 digits"
            return false
        }
        
        guard !expiryMonth.isEmpty, !expiryYear.isEmpty else {
            errorMessage = "Please enter expiry date"
            return false
        }
        
        guard cvv.count == 3 || cvv.count == 4 else {
            errorMessage = "CVV must be 3 or 4 digits"
            return false
        }
        
        return true
    }
    
    // MARK: - Reset Form
    func resetForm() {
        cardHolderName = ""
        cardNumber = ""
        expiryMonth = ""
        expiryYear = ""
        cvv = ""
        cardType = "Credit"
        errorMessage = nil
        editingCard = nil
    }
}
