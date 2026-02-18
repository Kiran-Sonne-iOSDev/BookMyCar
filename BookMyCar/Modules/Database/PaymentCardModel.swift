//
//  PaymentCardModel.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import Foundation
import SwiftData

@Model
final class PaymentCardModel: Identifiable {
    var id: UUID
    var cardHolderName: String
    var cardNumber: String
    var expiryMonth: String
    var expiryYear: String
    var cvv: String
    var cardType: String // "Credit" or "Debit"
    var isDefault: Bool
    var createdDate: Date
    
    init(
        cardHolderName: String,
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        cvv: String,
        cardType: String,
        isDefault: Bool = false
    ) {
        self.id = UUID()
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.cardType = cardType
        self.isDefault = isDefault
        self.createdDate = Date()
    }
    
    var maskedCardNumber: String {
        let last4 = String(cardNumber.suffix(4))
        return "**** **** **** \(last4)"
    }
    
    var formattedExpiry: String {
        return "\(expiryMonth)/\(expiryYear)"
    }
}
