//
//  OnboardingPresenter.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import Combine
import SwiftUI

class OnboardingPresenter: ObservableObject {
    // References to other VIPER components
    var interactor: OnboardingInteractorProtocol?
    var router: OnboardingRouter?
    
    // Data that View will display
    @Published var title: String = ""
    @Published var description: String = ""
    
    // MARK: - Called by View
    
    // When view appears
    func viewAppeared() {
        // Ask interactor to fetch data
        interactor?.fetchOnboardingData()
    }
    
    // When user taps button
    func getStartedButtonTapped() {
        print("Button tapped! Moving to next screen...")
        // Ask router to navigate to next screen
        router?.navigateToHome()
    }
    
    // MARK: - Called by Interactor
    
    // When interactor fetches data
    func didFetchData(_ data: OnboardingData) {
        // Update the view with data
        self.title = data.title
        self.description = data.description
    }
}
