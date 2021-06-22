//
//  AppRouter.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit

final class AppRouter {
    static let shared = AppRouter()
    
    func presentAsRoot(with viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func present(with viewController: UIViewController) {
        UIApplication.getTopViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        UIApplication.getTopViewController()?.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIApplication extensions for getting top view controller
extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
