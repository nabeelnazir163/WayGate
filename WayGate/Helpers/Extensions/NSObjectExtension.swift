//
//  NSObjectExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import Foundation
extension NSObject {
    public class var className: String {
        return String(describing: self.self)
    }
}
