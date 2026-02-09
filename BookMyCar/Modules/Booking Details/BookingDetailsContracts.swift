//
//  BookingDetailsContracts.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

 import Foundation

protocol BookingDetailsViewProtocol: AnyObject {
    func showError(_ message: String)
    func showSuccess(_ message: String)
}

protocol BookingDetailsPresenterProtocol {
    func onViewAppear()
    func callDriver()
    func bookRide()
}

protocol BookingDetailsInteractorProtocol {
    func fetchBookingDetails(bookingId: String)
    func confirmBooking(bookingId: String)
}

protocol BookingDetailsInteractorOutputProtocol: AnyObject {
    func didFetchBookingDetails(_ booking: BookingDetails)
    func didConfirmBooking(_ rideId: String)
    func didFailWithError(_ error: String)
}

protocol BookingDetailsRouterProtocol {
    func navigateToRideDetails(rideId: String)
    func navigateBack()
    func makePhoneCall(phoneNumber: String)
}
