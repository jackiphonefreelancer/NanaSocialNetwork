//
//  ProfileViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import Foundation
import RxSwift

class ProfileViewModel: NSObject {
    
    let logoutState = PublishSubject<Bool>() // Success or fail
}

//MARK: - View Logic
extension ProfileViewModel {
    var displayName: String {
        let appUser = AppSession.shared.appUser
        return appUser?.displayName ?? "-"
    }
    
    var email: String {
        let authUser = AppSession.shared.authUser
        return authUser?.email ?? "-"
    }
    
    var joinedAt: String {
        guard let appUser = AppSession.shared.appUser else {
            return "-"
        }
        return appUser.createdAt.string(format: "MMMM dd yyyy")
    }
}

//MARK: - API
extension ProfileViewModel {
    func logout() {
        AuthenticationManager.shared.logout(completion: { [weak self] success in
            self?.logoutState.onNext(success)
        })
    }
}
