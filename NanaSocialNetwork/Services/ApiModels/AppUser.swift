//
//  User.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation

struct AppUser: Codable {
    var uid: String
    var displayname: String
    var createdAt: Date
    var avatar: String?
}
