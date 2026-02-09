//
//  RideDetailsPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Combine
import SwiftUI

final class RideDetailsPresenter: ObservableObject {
    
    // MARK: - UI State
    @Published var rideDetails: RideDetails?
    @Published var selectedRating: Int = 0
    @Published var feedbackText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert: Bool = false
    @Published var successMessage: String = ""
    @Published var shouldNavigateToRideDetails = false

    let router: RideDetailsRouterProtocol
    private let interactor: RideDetailsInteractorProtocol
    let rideId: String
    
    init(interactor: RideDetailsInteractorProtocol,
         router: RideDetailsRouterProtocol,
         rideId: String) {
        self.interactor = interactor
        self.router = router
        self.rideId = rideId
    }
}

// MARK: - Presenter Protocol
extension RideDetailsPresenter: RideDetailsPresenterProtocol {
    
    func onViewAppear() {
        isLoading = true
        interactor.fetchRideDetails(rideId: rideId)
    }
    
    func selectRating(_ rating: Int) {
        selectedRating = rating
    }
    
    func updateFeedbackText(_ text: String) {
        feedbackText = text
    }
    
    func submitFeedback() {
        guard selectedRating > 0 else {
            errorMessage = "Please select a rating"
            return
        }
        
        guard !feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please provide feedback"
            return
        }
        
        isLoading = true
        interactor.submitFeedback(
            rideId: rideId,
            rating: selectedRating,
            comment: feedbackText
        )
    }
}

// MARK: - Interactor Output
extension RideDetailsPresenter: RideDetailsInteractorOutputProtocol {
    
    func didFetchRideDetails(_ ride: RideDetails) {
        self.rideDetails = ride
        isLoading = false
    }
    
    func didSubmitFeedback() {
        isLoading = false
        successMessage = "Thank you for your feedback!"
        showSuccessAlert = true
    }
    
    func didFailWithError(_ error: String) {
        errorMessage = error
        isLoading = false
    }
}
