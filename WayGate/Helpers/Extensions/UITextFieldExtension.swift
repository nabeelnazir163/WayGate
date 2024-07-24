//
//  UITextFieldExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 24/07/2024.
//

import UIKit

extension UITextField {
    
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return UIColor.placeHolderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: newValue])
        }
    }
}
