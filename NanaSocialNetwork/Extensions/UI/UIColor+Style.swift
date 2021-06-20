//
//  UIColor+Style.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import UIKit

// MARK: - Colors
extension UIColor {
    enum AppColor: String {
        case appBackgroundColor
        case appHeaderTextColor
        case appNormalTextColor
        case appTextFieldBackgroundColor
        case appThemeColor
        case appThemeTextColor
    }
    
    convenience init(_ appColor: AppColor) {
        self.init(named: appColor.rawValue)!
    }
}
