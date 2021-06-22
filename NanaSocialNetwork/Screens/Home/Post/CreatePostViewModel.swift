//
//  CreatePostViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import Foundation
import RxSwift

class CreatePostViewModel: NSObject {
    
    enum State {
        case none
        case loading
        case error
        case success
    }
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    let buttonState = BehaviorSubject(value: false) // Default - false
    
    private var message: String?
}

//MARK: - Business Logic
extension CreatePostViewModel {
    func updateMessage(_ message: String?) {
        self.message = message
        validateInput()
    }
    
    func validateInput() {
        guard let message = message, !message.isEmpty else {
            buttonState.onNext(false)
            return
        }
        buttonState.onNext(true)
    }
}

//MARK: - API
extension CreatePostViewModel {
    func createPost() {
        state.onNext(.loading)
        APIManager.shared.createPost(message: message!, completion: { [weak self] error in
            if let _ = error {
                self?.state.onNext(.error)
            } else {
                self?.state.onNext(.success)
            }
        })
    }
}
