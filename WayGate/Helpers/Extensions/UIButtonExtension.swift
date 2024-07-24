//
//  UIButtonExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import UIKit

extension UIButton {
    func setButton(enabled: Bool) {
        isUserInteractionEnabled = enabled
        backgroundColor = enabled ? .theme : .secondaryButton
        setTitleColor(enabled ? .white : .primaryText , for: .normal)
    }
}
