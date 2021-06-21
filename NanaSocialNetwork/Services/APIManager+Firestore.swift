//
//  APIManager+Firestore.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Firebase Firestore
extension APIManager {
    func createAppUserIfNeeded(uid: String, displayName: String, completion: @escaping (Bool, Error?) -> Void) {
        let docRef = db.collection("Users").document(uid)
        docRef.setData([ "uid": uid,
                         "displayname": displayName,
                         "createdAt": Date()
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchUserInfo(completion: @escaping (AppUser?, Error?) -> Void) {
        guard let authUser = authUser else {
            completion(nil, NSError.unknown)
            return
        }
        
        let docRef = db.collection("Users").document(authUser.uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let document = document, document.exists {
                    do {
                        let user = try document.data(as: AppUser.self)
                        completion(user, nil)
                    }
                    catch {
                        completion(nil, NSError.unknown)
                    }
                } else {
                    completion(nil, NSError.unknown)
                }
            }
        }
    }
}
