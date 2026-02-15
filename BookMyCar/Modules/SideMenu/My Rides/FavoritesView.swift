//
//  FavoritesView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 13/02/26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var presenter = FavoritesPresenter()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
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
                    // Custom Header
                    header
                    
                    // Content
                    if presenter.favoriteRides.isEmpty {
                        emptyState
                    } else {
                        favoritesList
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                presenter.modelContext = modelContext
                presenter.fetchFavorites()
            }
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
            
            Text("Favorites")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    // MARK: - Favorites List
    private var favoritesList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(presenter.favoriteRides) { ride in
                    VStack(alignment: .leading, spacing: 8) {
                        // Date & Time stamp
                        Text(presenter.formatDateTime(ride.bookingDate))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.yellow)
                            .cornerRadius(8)
                        
                        // Ride Card
                        RideHistoryCard(
                            ride: ride,
                            timeString: presenter.formatTime(ride.bookingDate),
                            onToggleFavorite: {
                                presenter.toggleFavorite(for: ride)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.7))
            
            Text("No favorites yet")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Mark your favorite rides to see them here!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
