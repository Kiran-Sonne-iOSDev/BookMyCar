//
//  PaymentMethod.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 15/02/26.
//

import Foundation

enum PaymentMethodType: String, Codable {
    case card = "Card"
    case upi = "UPI"
    case cod = "Cash on Delivery"
}

struct PaymentMethod: Identifiable {
    let id = UUID()
    let type: PaymentMethodType
    let displayName: String
    let icon: String
    var details: String? // For UPI ID or card number
    
    static let upi = PaymentMethod(
        type: .upi,
        displayName: "UPI Payment",
        icon: "indianrupeesign.circle.fill"
    )
    
    static let cod = PaymentMethod(
        type: .cod,
        displayName: "Cash on Delivery",
        icon: "banknote.fill"
    )
}
