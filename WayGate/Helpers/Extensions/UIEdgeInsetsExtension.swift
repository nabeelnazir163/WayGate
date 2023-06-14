//
//  UIEdgeInsetsExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 09/06/2023.
//

import SwiftUI

extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
