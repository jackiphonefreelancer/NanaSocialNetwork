//
//  APIManager.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Api Manager
final class APIManager: NSObject {
    // Global instance
    static let shared = APIManager()
    
    // Firestore instance
    let db = Firestore.firestore()
}

// MARK: - Authetication User
extension APIManager {
    var authUser: User? {
        return Auth.auth().currentUser
    }
}
