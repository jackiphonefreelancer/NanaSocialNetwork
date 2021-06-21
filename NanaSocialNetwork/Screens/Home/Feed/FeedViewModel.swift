//
//  FeedViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation
import RxSwift

class FeedViewModel: NSObject {
    
    enum State {
        case none
        case loading
        case error
        case success
    }
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    private var feeds = [FeedItem]()
}

// MARK: - TableView - DataSource
extension FeedViewModel {
    func numberOfItems() -> Int {
        return feeds.count
    }
    
    func feedItem(at index: Int) -> FeedItemCellViewModel {
        let feed = feeds[index]
        return FeedItemCellViewModel(displayName: feed.ownerName,
                                     text: feed.content,
                                     date: getDateString(feed.createdAt))
    }
}

//MARK: - Business Logic
extension FeedViewModel {
    func getDateString(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.string(format: "MMMM dd yyyy")
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
}
