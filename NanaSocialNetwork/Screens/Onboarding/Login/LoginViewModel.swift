//
//  LoginViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import Foundation
import RxSwift

class LoginViewModel: NSObject {
    
    enum State {
        case none
        case loading
        case error(LoginError)
        case success
    }
    
    let state = BehaviorSubject(value: State.none) // Default with none
}

//MARK: - Business Logic
extension LoginViewModel {
    func isValidEmail(email: String) -> Bool {
        return email.isValidEmail()
    }
}

//MARK: - API
extension LoginViewModel {
    func login(with email: String, password: String) {
        state.onNext(.loading)
        APIManager.shared.login(withEmail: email, password: password, completion: { [weak self] (succes, error) in
            if let error = error {
                self?.state.onNext(.error(error))
            } else {
                self?.state.onNext(.success)
            }
        })
    }
}
