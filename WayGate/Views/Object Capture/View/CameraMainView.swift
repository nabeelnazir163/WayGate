//
//  CameraMainView.swift
//  WayGate
//
//  Created by Nabeel Nazir on 07/10/2024.
//

import SwiftUI

struct GuidedCaptureSampleApp: App {
    static let subsystem: String = "com.waygatetest.waygate"
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                ContentView()
            }
        }
    }
}
