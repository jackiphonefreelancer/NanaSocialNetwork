//
//  AuthenticationManager.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import Foundation
import FirebaseAuth

// MARK: - Authentication Manager
enum LoginError {
    case wrongPassword // Indicates the user attempted sign in with an incorrect password
    case invalidEmail // Indicates the email address is malformed
    case unknown // Other reasons
}

enum CreateUserError {
    case emailAlreadyInUse // Indicates the email used to attempt sign up already exists
    case weakPassword // Indicates an attempt to set a password that is considered too weak
    case appUserAlreadyExists // Indicates the app user already exists in database
    case unknown // Other reasons
}

final class AuthenticationManager: NSObject {
    // Global instance
    static let shared = AuthenticationManager()
}

// MARK: - Firebase Authentication
extension AuthenticationManager {
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
    
    /**
     completion block: return 2 parameters
     param 1: User Id (uid)
     param 2 CreateUserError - EmailAlreadyInUse, weakPassword or unknown
     **/
    func createUser(withEmail email: String, password: String, completion: @escaping (String?, CreateUserError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(nil, .emailAlreadyInUse)
                case AuthErrorCode.weakPassword.rawValue:
                    completion(nil, .weakPassword)
                default:
                    completion(nil, .unknown)
                }
            } else if let uid = authResult?.user.uid {
                completion(uid, nil)
            } else {
                completion(nil, .unknown)
            }
        }
    }
    
    /**
     completion block: return  success or not
     **/
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            AppSession.shared.storeAppUser(nil)
            completion(true)
        } catch  {
            completion(false)
        }
    }
}
