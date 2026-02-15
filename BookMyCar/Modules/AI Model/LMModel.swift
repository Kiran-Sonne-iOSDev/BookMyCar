//
//  LMModel.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 14/02/26.
//

import SwiftUI
import FoundationModels
@Observable
class LMModel  {
    var inputText = "Hi"
    var isThinking = false
    var isAwaitingResponse = false
    var session = LanguageModelSession {
        """
        "You are a helpful and concise assistant. provide clear,accurate answers in a professional."
        """
    }
    
    func sendMessage(){
        Task {
            do {
                let prompt = Prompt(inputText)
                inputText = ""
                let strame = session.streamResponse(to: prompt)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isAwaitingResponse = true
                }
                for try await prontResponse in strame {
                    isAwaitingResponse = false
                    print(prontResponse)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
