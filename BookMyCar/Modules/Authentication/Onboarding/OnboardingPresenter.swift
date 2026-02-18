//
//  OnboardingPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import Combine
import SwiftUI

class OnboardingPresenter: ObservableObject {
    var interactor: OnboardingInteractorProtocol?
    var router: OnboardingRouter?
    // Data that View will display
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var imageName: String = ""
 
    // When view appears
    func viewAppeared() {
        interactor?.fetchOnboardingData()
    }
    
    // When user taps button
    func getStartedButtonTapped() {
        router?.navigateToVerification()
    }

    func didFetchData(_ data: OnboardingModel) {
        // Update the view with data
        self.imageName = data.imageName
        self.title = data.title
        self.description = data.description
        
        
    }
}
