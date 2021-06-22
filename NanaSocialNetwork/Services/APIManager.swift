//
//  APIManager.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Api Manager
final class APIManager: NSObject {
    // Global instance
    static let shared = APIManager()
    
    // Firestore instance
    let db = Firestore.firestore()
    
    override init() {
        super.init()
        configureFirestoreSettings()
    }
    
    func configureFirestoreSettings() {
        // Enable offline data persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
}

// MARK: - Firebase Firestore - Users
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
    
    func fetchUserInfo(uid: String, completion: @escaping (AppUser?, Error?) -> Void) {
        let docRef = db.collection("Users").document(uid)

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

// MARK: - Firebase Firestore - Posts
extension APIManager {
    func fetchFeedList(completion: @escaping ([FeedItem], Error?) -> Void) {
        let postsRef = db.collection("Posts")
        postsRef.order(by: "createdAt", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                completion([], error)
            } else {
                if let snapshot = snapshot {
                    let results = snapshot.documents.compactMap({ document in
                        return try? document.data(as: FeedItem.self)
                    })
                    completion(results, nil)
                } else {
                    completion([], NSError.unknown)
                }
            }
        }
    }
    
    func deletePost(postId: String, completion: @escaping (Error?) -> Void) {
        db.collection("Posts").document(postId).delete() { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
