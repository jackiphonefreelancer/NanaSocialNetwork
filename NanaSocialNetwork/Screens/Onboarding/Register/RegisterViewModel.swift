//
//  RegisterViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import RxSwift

class RegisterViewModel: NSObject {
    
    enum State {
        case none
        case loading
        case error(CreateUserError)
        case success
    }
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    let buttonState = BehaviorSubject(value: false) // Default - false
    
    private var email: String?
    private var password: String?
    private var displayname: String?
}

//MARK: - Business Logic
extension RegisterViewModel {
    func updateEmail(_ email: String?) {
        self.email = email
        validateInput()
    }
    
    func updatePaswword(_ password: String?) {
        self.password = password
        validateInput()
    }
    
    func updateDisplayname(_ displayname: String?) {
        self.displayname = displayname
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
    
    func isValidDisplayname() -> Bool {
        guard let displayname = displayname else {
            return false
        }
        return !displayname.isEmpty
    }
    
    func validateInput() {
        buttonState.onNext(isValidEmail() && isValidPassword() && isValidDisplayname())
    }
}

//MARK: - API
extension RegisterViewModel {
    func createUser() {
        state.onNext(.loading)
        APIManager.shared.createUser(withEmail: email!, password: password!, completion: { [weak self] (uid, error) in
            if let error = error {
                self?.state.onNext(.error(error))
            } else if let uid = uid {
                self?.createAppUserIfNeeded(uid: uid)
            } else {
                self?.state.onNext(.error(.unknown))
            }
        })
    }
    
    func createAppUserIfNeeded(uid: String) {
        state.onNext(.loading)
        APIManager.shared.createAppUserIfNeeded(uid: uid, displayName: displayname!, completion: { [weak self] (uid, error) in
            if let _ = error {
                self?.state.onNext(.error(.unknown))
            } else {
                self?.state.onNext(.success)
            }
        })
    }
}
