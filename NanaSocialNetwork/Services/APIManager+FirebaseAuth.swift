//
//  APIManager+FirebaseAuth.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import FirebaseAuth

// MARK: - Firebase Authentication
enum LoginError {
    case wrongPassword
    case invalidEmail
    case unknown
}

extension APIManager {
    /**
     completion block: return 2 parameters
     param 1: Success - (true: sucess, false fail)
     param 2 LoginError - Wrong password, invalid email or unknown
     **/
    func login(withEmail email: String, password: String, completion: @escaping (Bool, LoginError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(false, .wrongPassword)
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(false, .invalidEmail)
                default:
                    completion(false, .unknown)
                }
            } else {
                completion(true, nil)
            }
        }
    }
}
