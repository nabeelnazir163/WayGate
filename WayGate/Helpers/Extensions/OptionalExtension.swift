//
//  OptionalExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

extension Optional {
    public var isNone: Bool {
        return self == nil
    }
    public var isSome: Bool {
        return self != nil
    }
}
