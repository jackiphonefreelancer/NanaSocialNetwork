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
    let canDelete: Bool
}

class FeedItemCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteTapped: (() -> Void)?
    
    func fill(_ item: FeedItemCellViewModel) {
        // Image
        displayNameLabel.text = item.displayName
        contentTextLabel.text = item.text
        dateLabel.text = item.date
        deleteButton.isHidden = !item.canDelete
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        deleteTapped?()
    }
}

extension FeedItemCell: NibInstanceable, Reuseable {
    static let reuseId = "FeedItemCell"
    static func nibName() -> String {
        return "FeedItemCell"
    }
}
