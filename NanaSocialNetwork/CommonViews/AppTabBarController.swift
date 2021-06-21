//
//  AppTabBarController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Storyboard
extension AppTabBarController {
    static func storyboardInstance() -> AppTabBarController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AppTabBarController")
            as! AppTabBarController
    }
}
