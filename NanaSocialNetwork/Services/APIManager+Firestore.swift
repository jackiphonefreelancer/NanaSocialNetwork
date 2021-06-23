//
//  APIManager+Firestore.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/23/21.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Firebase Firestore - Users
extension APIManager {
    /**
     `completion block`: return 1 parameter
     `param 1`: If success return no error, else return error
     **/
    func createAppUserIfNeeded(uid: String, displayName: String, completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("Users").document(uid)
        docRef.setData([ "uid": uid,
                         "displayName": displayName,
                         "createdAt": Date()
        ]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     `completion block`: return 2 parameters
     `param 1`: If success return app user, else nil
     `param 2`: If success return no error, else return error
     **/
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
    /**
     `completion block`: return 2 parameters
     `param 1`: If success return feed items list, else nil
     `param 2`: If success return no error, else return error
     **/
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
    
    /**
     `completion block`: return 1 parameter
     `param 1`: If success return no error, else return error
     **/
    func createPost(message: String, completion: @escaping (Error?) -> Void) {
        guard let user = AppSession.shared.appUser else {
            completion(NSError.unknown)
            return
        }
        db.collection("Posts").addDocument(data: [
            "content": message,
            "createdAt": Date(),
            "ownerId": user.uid,
            "ownerName": user.displayName
        ]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     `completion block`: return 1 parameter
     `param 1`: If success return no error, else return error
     **/
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
