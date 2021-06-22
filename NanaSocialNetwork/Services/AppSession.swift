//
//  AppSession.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import Foundation
import FirebaseAuth


final class AppSession: NSObject {
    // Singletion instance
    static let shared = AppSession()
    
    // Keychain & App User
    private var keychain = Keychain.default
    private(set) var appUser: AppUser?
    
    override init() {
        super.init()
        appUser = getAppUser()
    }
}

// MARK: - App User
extension AppSession {
    enum DataKey: String {
        case appUser = "AppUser"
    }
    
    func storeAppUser(_ appUser: AppUser?) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(appUser) {
            keychain.set(data: data, forKey: DataKey.appUser.rawValue)
        }
        self.appUser = appUser
    }
    
    func getAppUser() -> AppUser? {
        guard let data = keychain.data(forKey: DataKey.appUser.rawValue) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(AppUser.self, from: data)
    }
}

// MARK: - Authetication User
extension AppSession {
    var authUser: User? {
        return Auth.auth().currentUser
    }
}
