//
//  LoginViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/19/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: - Storyboard
extension LoginViewController {
    static func storyboardInstance() -> LoginViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            as! LoginViewController
    }
}
