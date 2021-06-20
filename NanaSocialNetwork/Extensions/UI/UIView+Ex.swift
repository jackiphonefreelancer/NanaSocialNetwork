//
//  UIView+Ex.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import UIKit

//MARK: - AutoLayout
extension UIView {
    @discardableResult
    func autoFit(toView view: UIView, edges: UIRectEdge = .all, offset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top))
        }
        if edges.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset.left))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset.bottom))
        }
        if edges.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset.right))
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func autoFitSuperView(edges: UIRectEdge = .all, offset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return []
        }
        return autoFit(toView: superview, edges: edges, offset: offset)
    }

    @discardableResult
    func autoCenter(toView view: UIView, offset: CGSize = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.width))
        constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.height))
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func autoCenterSuperView(offset: CGSize = .zero) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return []
        }
        return autoCenter(toView: superview, offset: offset)
    }

    func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat) {
        var mask = CACornerMask()
        if corners.contains(.topLeft) {
            mask = mask.union(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            mask = mask.union(.layerMaxXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
            mask = mask.union(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            mask = mask.union(.layerMaxXMaxYCorner)
        }
        layer.maskedCorners = mask
        cornerRadius = radius
    }
}

//MARK: - Lock and Unlock View
extension UIView {
    func lock() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
    
    func unlock() {
        self.isUserInteractionEnabled = true
        self.alpha = 1.0
    }
}
