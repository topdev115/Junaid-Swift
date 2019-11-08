//
//  PaddingTextField.swift
//  junaid
//
//  Created by Administrator on 2019/10/23.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderColor = UIColor.red.cgColor
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func warning() {
        layer.borderWidth = 1.0
    }
    
    func invalidate() {
        layer.borderWidth = 0.0
    }
    
    func isEmpty() -> Bool? {
        if self.text!.isEmpty {
            layer.borderWidth = 1.0
        }
        
        return self.text?.isEmpty
    }
}

class PaddingTextView: UITextView {
    
    static let PLACEHOLDER = "Your Feedback...".localizedString
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    fileprivate func initialize() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        clipsToBounds = true
        
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func warning() {
        layer.borderColor = UIColor.red.cgColor
    }
    
    func invalidate() {
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func isEmpty() -> Bool? {
        if self.text! == PaddingTextView.PLACEHOLDER {
            layer.borderColor = UIColor.red.cgColor
            return true
        }
        
        return false
    }
}
