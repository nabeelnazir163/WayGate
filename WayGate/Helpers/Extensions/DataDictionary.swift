//
//  DataDictionary.swift
//  WayGate
//
//  Created by Nabeel Nazir on 01/06/2023.
//

import Foundation

extension Data {
    func toDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
