//
//  AppPosts.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation

struct FeedItem: Codable {
    var content: String
    var createdAt: Date
    var ownerId: String
    var ownerName: String
}
