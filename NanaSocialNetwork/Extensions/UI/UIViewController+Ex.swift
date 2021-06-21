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

//MARK: - Toast Message
extension UIViewController {
    func showToastMessage(_ message: String, duration: Double = 2.0){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor(.appTextFieldBackgroundColor)
        alert.view.layer.cornerRadius = 15.0
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
