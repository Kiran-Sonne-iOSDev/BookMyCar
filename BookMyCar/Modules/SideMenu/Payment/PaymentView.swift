//
//  PaymentView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

//import SwiftUI
//import SwiftData
//
//struct PaymentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var presenter = PaymentPresenter()
//    
//    var body: some View {
//        ZStack {
//            // Background gradient
//            LinearGradient(
//                colors: [
//                    Color(hex: "FF9800"),
//                    Color(hex: "FFC107")
//                ],
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                // Header
//                header
//                
//                // Content
//                if presenter.savedCards.isEmpty {
//                    emptyState
//                } else {
//                    cardsList
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .onAppear {
//            presenter.modelContext = modelContext
//            presenter.fetchCards()
//        }
//        .sheet(isPresented: $presenter.showAddCardSheet) {
//            AddCardView(presenter: presenter)
//        }
//    }
//    
//    // MARK: - Header
//    private var header: some View {
//        HStack {
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(.white)
//                    .frame(width: 44, height: 44)
//            }
//            
//            Spacer()
//            
//            Text("Payment")
//                .font(.system(size: 20, weight: .bold))
//                .foregroundColor(.white)
//            
//            Spacer()
//            
//            Button {
//                presenter.showAddCardSheet = true
//            } label: {
//                Image(systemName: "plus.circle.fill")
//                    .font(.system(size: 28))
//                    .foregroundColor(.white)
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 50)
//        .padding(.bottom, 20)
//    }
//    
//    // MARK: - Cards List
//    private var cardsList: some View {
//        ScrollView(showsIndicators: false) {
//            VStack(spacing: 20) {
//                ForEach(presenter.savedCards) { card in
//                    PaymentCardView(
//                        card: card,
//                        onDelete: {
//                            presenter.deleteCard(card)
//                        },
//                        onSetDefault: {
//                            presenter.setDefaultCard(card)
//                        }
//                    )
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 20)
//        }
//        .background(Color.white)
//        .cornerRadius(30, corners: [.topLeft, .topRight])
//    }
//    
//    // MARK: - Empty State
//    private var emptyState: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "creditcard.fill")
//                .font(.system(size: 60))
//                .foregroundColor(.white.opacity(0.7))
//            
//            Text("No payment methods")
//                .font(.system(size: 22, weight: .semibold))
//                .foregroundColor(.white)
//            
//            Text("Add a card to get started")
//                .font(.system(size: 16))
//                .foregroundColor(.white.opacity(0.8))
//            
//            Button {
//                presenter.showAddCardSheet = true
//            } label: {
//                Text("Add Card")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.orange)
//                    .padding(.horizontal, 32)
//                    .padding(.vertical, 12)
//                    .background(Color.white)
//                    .cornerRadius(25)
//            }
//            .padding(.top, 10)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
import SwiftUI
import SwiftData

struct PaymentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var presenter = PaymentPresenter()
    
    var body: some View {
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
                header
                
                if presenter.savedCards.isEmpty {
                    emptyState
                } else {
                    cardsList
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            presenter.modelContext = modelContext
            presenter.fetchCards()
        }
        .sheet(isPresented: $presenter.showAddCardSheet) {
            AddCardView(presenter: presenter)
        }
        .sheet(isPresented: $presenter.showEditCardSheet) {
            EditCardView(presenter: presenter)
        }
    }
    
    // MARK: - Header
    private var header: some View {
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
            
            Text("Payment")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                presenter.showAddCardSheet = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    // MARK: - Cards List
    private var cardsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(presenter.savedCards) { card in
                    PaymentCardView(
                        card: card,
                        onDelete: {
                            presenter.deleteCard(card)
                        },
                        onSetDefault: {
                            presenter.setDefaultCard(card)
                        },
                        onEdit: {
                            presenter.prepareEdit(card: card)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
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
            
            Text("Add a card to get started")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
            
            Button {
                presenter.showAddCardSheet = true
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
}
