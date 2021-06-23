//
//  PhotoCropperOverlayView.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/23/21.
//

import UIKit

final class PhotoCropperOverlayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = false
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let boundingPath = UIBezierPath(rect: rect)
        let width = rect.width
        let height: CGFloat = rect.height
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if width > height {
            dx = (width - height) * 0.5
        } else {
            dy = (height - width) * 0.5
        }

        let square = rect.insetBy(dx: dx, dy: dy)
        let higlightRectPath = UIBezierPath(rect: square)
        context.addPath(boundingPath.cgPath)
        context.addPath(higlightRectPath.cgPath)
        context.setFillColor(UIColor.black.withAlphaComponent(0.6).cgColor)
        context.fillPath(using: CGPathFillRule.evenOdd)
    }
}
