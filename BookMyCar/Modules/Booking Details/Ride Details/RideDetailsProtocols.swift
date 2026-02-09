//
//  RideDetailsProtocols.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

import Foundation

protocol RideDetailsViewProtocol: AnyObject {
    func showError(_ message: String)
    func showSuccess(_ message: String)
}

protocol RideDetailsPresenterProtocol {
    func onViewAppear()
    func selectRating(_ rating: Int)
    func updateFeedbackText(_ text: String)
    func submitFeedback()
}

protocol RideDetailsInteractorProtocol {
    func fetchRideDetails(rideId: String)
    func submitFeedback(rideId: String, rating: Int, comment: String)
}

protocol RideDetailsInteractorOutputProtocol: AnyObject {
    func didFetchRideDetails(_ ride: RideDetails)
    func didSubmitFeedback()
    func didFailWithError(_ error: String)
}

protocol RideDetailsRouterProtocol {
    func navigateToHome()
}
