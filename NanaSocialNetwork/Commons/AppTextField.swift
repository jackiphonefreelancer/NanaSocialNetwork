//
//  AppTextField.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/20/21.
//

import UIKit

class AppTextField: UITextField {

    private let placeHolderLabel = UILabel()
    private let padding: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: padding, dy: 4)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: padding, dy: 4)
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let isAssigned = super.becomeFirstResponder()
        if isAssigned {
            togglePlaceHolder(true)
        }
        return isAssigned
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let isResigned = super.resignFirstResponder()
        if isResigned && (text == nil || text?.isEmpty == true) {
            togglePlaceHolder(false)
        }
        return isResigned
    }

    override var placeholder: String? {
        set {
            placeHolderLabel.text = newValue
        }
        get {
            return placeHolderLabel.text
        }
    }

    override var text: String? {
        set {
            super.text = newValue
            textChanged()
        }
        get {
            return super.text
        }
    }

    // MARK: - Privates
    private func initialize() {
        clipsToBounds = true
        addSubview(placeHolderLabel)
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14.0)
        placeHolderLabel.textColor = UIColor(.appNormalTextColor).withAlphaComponent(0.5)
        placeHolderLabel.frame = bounds.insetBy(dx: padding, dy: 4)

        addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    private var isShrink = false
    private func togglePlaceHolder(_ isShrink: Bool) {
        self.isShrink = isShrink

        var placeHolderFrame = bounds.insetBy(dx: padding, dy: -2)
        if isShrink {
            placeHolderFrame.size.height = 26
        }
        let font = UIFont.systemFont(ofSize: isShrink ? 11.0 : 14.0)
        UIView.animate(withDuration: 0.25) {
            self.placeHolderLabel.font = font
            self.placeHolderLabel.frame = placeHolderFrame
        }
    }

    @objc func textChanged() {
        let isShrink = isFirstResponder || !(text == nil || text?.isEmpty == true)
        if isShrink != self.isShrink {
            togglePlaceHolder(isShrink)
        }
    }
}
