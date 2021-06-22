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
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    let buttonState = BehaviorSubject(value: false) // Default - false
    private var email: String?
    private var password: String?
}

//MARK: - Business Logic
extension LoginViewModel {
    func updateEmail(_ email: String?) {
        self.email = email
        validateInput()
    }
    
    func updatePaswword(_ password: String?) {
        self.password = password
        validateInput()
    }
    
    func isValidEmail() -> Bool {
        guard let email = email else {
            return false
        }
        return email.isValidEmail()
    }
    
    func isValidPassword() -> Bool {
        guard let password = password else {
            return false
        }
        return !password.isEmpty
    }
    
    func validateInput() {
        buttonState.onNext(isValidEmail() && isValidPassword())
    }
}

//MARK: - API
extension LoginViewModel {
    func login() {
        state.onNext(.loading)
        AuthenticationManager.shared.login(withEmail: email!, password: password!, completion: { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error))
            } else {
                self?.state.onNext(.success)
            }
        })
    }
}
