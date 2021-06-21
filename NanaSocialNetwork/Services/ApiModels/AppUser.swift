//
//  User.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import FirebaseFirestoreSwift

struct AppUser: Codable {
    @DocumentID var id: String? 
    var uid: String
    var displayname: String
    var createdAt: Date
}
