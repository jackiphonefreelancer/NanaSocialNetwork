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

//MARK: - API + Authentication
extension LoginViewModel {
    func login() {
        state.onNext(.loading)
        APIManager.shared.login(withEmail: email!, password: password!, completion: { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error))
            } else {
                // Once user logged in, fetch user info
                self?.fetchUserInfo()
            }
        })
    }
    
    func fetchUserInfo() {
        guard let uid = AppSession.shared.authUser?.uid else {
            state.onNext(.error(.unknown))
            return
        }
        APIManager.shared.fetchUserInfo(uid: uid, completion: { [weak self] (user, error) in
            if let user = user {
                AppSession.shared.storeAppUser(user)
                self?.state.onNext(.success)
            } else {
                self?.state.onNext(.error(.unknown))
            }
        })
    }
}
