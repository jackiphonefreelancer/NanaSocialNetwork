//
//  FeedItemCell.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit

struct FeedItemCellViewModel {
    let displayName: String
    let text: String
    let date: String
}

class FeedItemCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func fill(_ item: FeedItemCellViewModel) {
        // Image
        displayNameLabel.text = item.displayName
        contentTextLabel.text = item.text
        dateLabel.text = item.date
    }
}

extension FeedItemCell: NibInstanceable, Reuseable {
    static let reuseId = "FeedItemCell"
    static func nibName() -> String {
        return "FeedItemCell"
    }
}
