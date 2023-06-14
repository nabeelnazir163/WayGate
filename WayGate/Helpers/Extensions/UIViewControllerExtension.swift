//
//  UIViewControllerExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /**
     This will dismiss the keyboard
     */
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}
