//
//  FeedViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import RxSwift
import FirebaseAuth

class FeedViewModel: NSObject {
    
    enum State {
        case none // Initial value with nothing
        case loading // Loading
        case error // Get error from API
        case success // Get resopnse from API
        case reload // Change feed type. requires to reload view
        case deleted // Delete post
    }
    
    enum FeedType: Int {
        case timeline = 0 // Show all
        case myPosts = 1 // Show only my posts
    }
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    private var feeds = [FeedItem]()
    private var feedType = FeedType.timeline {
        didSet {
            state.onNext(.reload)
        }
    }
}

// MARK: - TableView - DataSource
extension FeedViewModel {
    var filteredFeeds: [FeedItem] {
        switch feedType {
        case .timeline:
            return feeds
        case .myPosts:
            guard let uid = Auth.auth().currentUser?.uid else {
                return []
            }
            return feeds.filter({$0.ownerId == uid})
        }
    }
    
    func numberOfItems() -> Int {
        return filteredFeeds.count
    }
    
    func feedItem(at index: Int) -> FeedItemCellViewModel {
        let feed = filteredFeeds[index]
        return FeedItemCellViewModel(displayName: feed.ownerName,
                                     text: feed.content,
                                     date: feed.createdAt.timeAgoDisplay(),
                                     canDelete: feed.ownerId == Auth.auth().currentUser?.uid)
    }
    
    func getDoucmentId(at index: Int) -> String? {
        return filteredFeeds[index].id
    }
}

//MARK: - Business Logic
extension FeedViewModel {
    func updateFeedType(at index: Int) {
        if index == 0 {
            self.feedType = .timeline
        } else {
            self.feedType = .myPosts
        }
    }
}

//MARK: - API
extension FeedViewModel {
    func fetchFeedList() {
        state.onNext(.loading)
        APIManager.shared.fetchFeedList(completion: { [weak self] (result, error) in
            if let _ = error {
                self?.state.onNext(.error)
            } else {
                self?.feeds = result
                self?.state.onNext(.success)
            }
        })
    }
    
    func deletePost(id: String) {
        state.onNext(.loading)
        APIManager.shared.deletePost(postId: id, completion: { [weak self] (error) in
            if let _ = error {
                self?.state.onNext(.error)
            } else {
                self?.state.onNext(.deleted)
                self?.fetchFeedList()
            }
        })
    }
}
