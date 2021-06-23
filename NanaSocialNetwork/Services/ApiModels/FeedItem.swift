//
//  AppPosts.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FeedItem: Codable {
    @DocumentID var id: String? 
    var content: String
    var image: String?
    var createdAt: Date
    var ownerId: String
    var ownerName: String
}
