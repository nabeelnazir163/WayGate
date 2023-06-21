//
//  UserDefaultConfig.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else{ return defaultValue}
            
            do{
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            }catch let error{
                print(error.localizedDescription)
                return defaultValue
            }
        }
        set {
            do{
                let encodedData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: key)
                UserDefaults.standard.synchronize()
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault("user", defaultValue: nil)
    static var user: User?
    
    @UserDefault("isFirstLaunch", defaultValue: true)
    static var isFirstLaunch: Bool
}
