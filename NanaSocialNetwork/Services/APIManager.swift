//
//  APIManager.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class APIManager: NSObject {
    // Global instance
    static let shared = APIManager()
    
    // Firestore instance
    let db = Firestore.firestore()
    
    // Firebase storage instance
    let storage = Storage.storage()
    
    override init() {
        super.init()
        configureFirestoreSettings()
    }
}

// MARK: - Firestore Configuration
extension APIManager {
    func configureFirestoreSettings() {
        // Enable offline data persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
}
