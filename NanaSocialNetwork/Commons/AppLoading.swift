//
//  AppLoading.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import UIKit

public class AppLoading {

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var bgView = UIView()

    class var shared: AppLoading {
        struct Static {
            static let instance: AppLoading = AppLoading()
        }
        return Static.instance
    }

    public func showLoading(in viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) {
        guard let view = viewController?.view else {
            return
        }
        bgView.frame = view.bounds
        bgView.backgroundColor = UIColor.clear
        bgView.addSubview(overlayView)
        bgView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin,.flexibleHeight, .flexibleWidth]
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        overlayView.backgroundColor = UIColor.black
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

        overlayView.addSubview(activityIndicator)
        view.addSubview(bgView)
        self.activityIndicator.startAnimating()

    }

    public func hideLoading() {
        activityIndicator.stopAnimating()
        bgView.removeFromSuperview()
    }
}
