//
//  User.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import FirebaseFirestoreSwift

struct AppUser: Codable {
    var uid: String
    var displayName: String
    var createdAt: Date
}
