//
//  BookingDetailsPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//


import Combine
import SwiftUI

final class BookingDetailsPresenter: ObservableObject {
    
    // MARK: - UI State
    @Published var bookingDetails: BookingDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let router: BookingDetailsRouterProtocol
    private let interactor: BookingDetailsInteractorProtocol
    private let bookingId: String
    
    init(interactor: BookingDetailsInteractorProtocol,
         router: BookingDetailsRouterProtocol,
         bookingId: String) {
        self.interactor = interactor
        self.router = router
        self.bookingId = bookingId
    }
}

// MARK: - Presenter Protocol
extension BookingDetailsPresenter: BookingDetailsPresenterProtocol {
    
    func onViewAppear() {
        isLoading = true
        interactor.fetchBookingDetails(bookingId: bookingId)
    }
    
    func callDriver() {
        guard let phoneNumber = bookingDetails?.driverPhone else { return }
        router.makePhoneCall(phoneNumber: phoneNumber)
    }
    
    func bookRide() {
        isLoading = true
        interactor.confirmBooking(bookingId: bookingId)
    }
}

// MARK: - Interactor Output
extension BookingDetailsPresenter: BookingDetailsInteractorOutputProtocol {
    
    func didFetchBookingDetails(_ booking: BookingDetails) {
        self.bookingDetails = booking
        isLoading = false
    }
    
    func didConfirmBooking(_ rideId: String) {
        isLoading = false
        router.navigateToRideDetails(rideId: rideId)
    }
    
    func didFailWithError(_ error: String) {
        errorMessage = error
        isLoading = false
    }
}
