//
//  UIViewController+Ex.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import UIKit

// MARK: - Error Dialog
extension UIViewController {
    @discardableResult
    func showErrorDialog(title: String? = nil, message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        return alert
    }
}
