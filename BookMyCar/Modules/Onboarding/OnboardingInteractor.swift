//
//  OnboardingInteractor.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
//

import Foundation
import Foundation

// Protocol: What Interactor can do
protocol OnboardingInteractorProtocol {
    func fetchOnboardingData()
}

class OnboardingInteractor: OnboardingInteractorProtocol {
    // Reference to presenter (to send data back)
    weak var presenter: OnboardingPresenter?
    
    // Fetch the onboarding data
    func fetchOnboardingData() {
        // In real app, this might come from API or database
        // For now, we just create it here
        let data = OnboardingData(
            title: "TAXI SERVICE",
            description: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit"
        )
        
        // Send data back to presenter
        presenter?.didFetchData(data)
    }
}
