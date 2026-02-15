//
//  AddCardView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

//import SwiftUI
//
//struct AddCardView: View {
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject var presenter: PaymentPresenter
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(hex: "F5F5F5")
//                    .ignoresSafeArea()
//                
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 24) {
//                        // Card Preview
//                        cardPreview
//                        
//                        // Form
//                        formFields
//                        
//                        // Add Button
//                        addButton
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                }
//            }
//            .navigationTitle("Add Card")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Card Preview
//    private var cardPreview: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text(presenter.cardType.uppercased())
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(Color.orange)
//                    .cornerRadius(6)
//                
//                Spacer()
//            }
//            
//            Text(formatCardNumber(presenter.cardNumber))
//                .font(.system(size: 20, weight: .semibold))
//                .foregroundColor(.white)
//                .tracking(2)
//            
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Card holder")
//                        .font(.system(size: 11))
//                        .foregroundColor(.white.opacity(0.8))
//                    Text(presenter.cardHolderName.isEmpty ? "Name" : presenter.cardHolderName)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.white)
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .trailing, spacing: 4) {
//                    Text("Valid")
//                        .font(.system(size: 11))
//                        .foregroundColor(.white.opacity(0.8))
//                    Text("\(presenter.expiryMonth.isEmpty ? "MM" : presenter.expiryMonth)/\(presenter.expiryYear.isEmpty ? "YY" : presenter.expiryYear)")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.white)
//                }
//            }
//        }
//        .padding(24)
//        .frame(height: 200)
//        .background(
//            LinearGradient(
//                colors: [Color.yellow, Color.orange],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
//    }
//    
//    // MARK: - Form Fields
//    private var formFields: some View {
//        VStack(spacing: 16) {
//            // Card Type Picker
//            Picker("Card Type", selection: $presenter.cardType) {
//                Text("Credit").tag("Credit")
//                Text("Debit").tag("Debit")
//            }
//            .pickerStyle(.segmented)
//            
//            // Cardholder Name
//            CustomTextField(
//                icon: "person.fill",
//                placeholder: "Cardholder Name",
//                text: $presenter.cardHolderName
//            )
//            
//            // Card Number
//            CustomTextField(
//                icon: "creditcard.fill",
//                placeholder: "Card Number",
//                text: $presenter.cardNumber
//            )
//            .keyboardType(.numberPad)
//            .onChange(of: presenter.cardNumber) { newValue in
//                presenter.cardNumber = formatCardInput(newValue)
//            }
//            
//            // Expiry & CVV
//            HStack(spacing: 16) {
//                CustomTextField(
//                    icon: "calendar",
//                    placeholder: "MM",
//                    text: $presenter.expiryMonth
//                )
//                .keyboardType(.numberPad)
//                .frame(width: 80)
//                
//                CustomTextField(
//                    icon: "calendar",
//                    placeholder: "YY",
//                    text: $presenter.expiryYear
//                )
//                .keyboardType(.numberPad)
//                .frame(width: 80)
//                
//                CustomTextField(
//                    icon: "lock.fill",
//                    placeholder: "CVV",
//                    text: $presenter.cvv
//                )
//                .keyboardType(.numberPad)
//            }
//            
//            // Error Message
//            if let error = presenter.errorMessage {
//                Text(error)
//                    .font(.system(size: 14))
//                    .foregroundColor(.red)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .padding(.horizontal, 4)
//    }
//    
//    // MARK: - Add Button
//    private var addButton: some View {
//        Button {
//            presenter.addCard()
//        } label: {
//            Text("Add Card")
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .frame(height: 56)
//                .background(
//                    LinearGradient(
//                        colors: [Color.yellow, Color.orange],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//                .cornerRadius(28)
//                .shadow(color: Color.orange.opacity(0.4), radius: 10, x: 0, y: 5)
//        }
//        .padding(.top, 20)
//    }
//    
//    // MARK: - Helper Functions
//    private func formatCardInput(_ input: String) -> String {
//        let cleaned = input.replacingOccurrences(of: " ", with: "")
//        let limited = String(cleaned.prefix(16))
//        
//        var formatted = ""
//        for (index, char) in limited.enumerated() {
//            if index > 0 && index % 4 == 0 {
//                formatted += " "
//            }
//            formatted.append(char)
//        }
//        return formatted
//    }
//    
//    private func formatCardNumber(_ number: String) -> String {
//        if number.isEmpty {
//            return "0000 0000 0000 0000"
//        }
//        return number
//    }
//}
//
//// MARK: - Custom TextField
//struct CustomTextField: View {
//    let icon: String
//    let placeholder: String
//    @Binding var text: String
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: icon)
//                .font(.system(size: 16))
//                .foregroundColor(.gray)
//                .frame(width: 24)
//            
//            TextField(placeholder, text: $text)
//                .font(.system(size: 16))
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//}
import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var presenter: PaymentPresenter
    
    @State private var isCardFlipped = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case cardHolder, cardNumber, expiryMonth, expiryYear, cvv
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F5F5F5")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Card Preview with Flip
                        cardPreviewWithFlip
                        
                        // Form
                        formFields
                        
                        // Add Button
                        addButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: focusedField) { newField in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isCardFlipped = (newField == .cvv)
                }
            }
            .onChange(of: presenter.cvv) { newValue in
                // Auto flip back after 3 digits
                if newValue.count >= 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isCardFlipped = false
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Card Preview with Flip
    private var cardPreviewWithFlip: some View {
        ZStack {
            // Front of Card
            cardFront
                .rotation3DEffect(
                    .degrees(isCardFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isCardFlipped ? 0 : 1)
            
            // Back of Card
            cardBack
                .rotation3DEffect(
                    .degrees(isCardFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isCardFlipped ? 1 : 0)
        }
        .frame(height: 200)
    }
    
    // MARK: - Card Front
    private var cardFront: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(presenter.cardType.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .cornerRadius(6)
                
                Spacer()
            }
            
            Text(formatCardNumber(presenter.cardNumber))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .tracking(2)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Card holder")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                    Text(presenter.cardHolderName.isEmpty ? "Name" : presenter.cardHolderName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Valid")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(presenter.expiryMonth.isEmpty ? "MM" : presenter.expiryMonth)/\(presenter.expiryYear.isEmpty ? "YY" : presenter.expiryYear)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.yellow, Color.orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Card Back
    private var cardBack: some View {
        VStack(spacing: 0) {
            // Magnetic Strip
            Rectangle()
                .fill(Color.black)
                .frame(height: 40)
                .padding(.top, 20)
            
            Spacer()
            
            // CVV Section
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("CVV")
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.6))
                    
                    Text(presenter.cvv.isEmpty ? "***" : presenter.cvv)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(6)
                }
                .padding(.trailing, 24)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.orange, Color.yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .rotation3DEffect(
            .degrees(180),
            axis: (x: 0, y: 1, z: 0)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Form Fields
    private var formFields: some View {
        VStack(spacing: 16) {
            // Card Type Picker
            Picker("Card Type", selection: $presenter.cardType) {
                Text("Credit").tag("Credit")
                Text("Debit").tag("Debit")
            }
            .pickerStyle(.segmented)
            
            // Cardholder Name
            CustomTextField(
                icon: "person.fill",
                placeholder: "Cardholder Name",
                text: $presenter.cardHolderName
            )
            .focused($focusedField, equals: .cardHolder)
            .onChange(of: presenter.cardHolderName) { newValue in
                 presenter.cardHolderName = newValue.filter { $0.isLetter || $0.isWhitespace }
            }
            
            // Card Number
            CustomTextField(
                icon: "creditcard.fill",
                placeholder: "Card Number",
                text: $presenter.cardNumber
            )
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .cardNumber)
            .onChange(of: presenter.cardNumber) { newValue in
                presenter.cardNumber = formatCardInput(newValue)
            }
            
            // Expiry & CVV
            HStack(spacing: 16) {
                CustomTextField(
                    icon: "calendar",
                    placeholder: "MM",
                    text: $presenter.expiryMonth
                )
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .expiryMonth)
                .frame(width: 80)
                .onChange(of: presenter.expiryMonth) { newValue in
                    if newValue.count > 2 {
                        presenter.expiryMonth = String(newValue.prefix(2))
                    }
                }
                
                CustomTextField(
                    icon: "calendar",
                    placeholder: "YY",
                    text: $presenter.expiryYear
                )
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .expiryYear)
                .frame(width: 80)
                .onChange(of: presenter.expiryYear) { newValue in
                    if newValue.count > 2 {
                        presenter.expiryYear = String(newValue.prefix(2))
                    }
                }
                
                CustomTextField(
                    icon: "lock.fill",
                    placeholder: "CVV",
                    text: $presenter.cvv
                )
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .cvv)
                .onChange(of: presenter.cvv) { newValue in
                    if newValue.count > 4 {
                        presenter.cvv = String(newValue.prefix(4))
                    }
                }
            }
            
            // Error Message
            if let error = presenter.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            presenter.addCard()
        } label: {
            Text("Add Card")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: Color.orange.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Helper Functions
    private func formatCardInput(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: " ", with: "")
        let limited = String(cleaned.prefix(16))
        
        var formatted = ""
        for (index, char) in limited.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        return formatted
    }
    
    private func formatCardNumber(_ number: String) -> String {
        if number.isEmpty {
            return "0000 0000 0000 0000"
        }
        return number
    }
}

// MARK: - Custom TextField
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .frame(width: 24)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
