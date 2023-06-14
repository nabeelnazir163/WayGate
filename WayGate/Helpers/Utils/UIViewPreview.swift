//
//  UIViewPreview.swift
//  WayGate
//
//  Created by Nabeel Nazir on 09/06/2023.
//

import SwiftUI

struct UIViewPreview<V: UIView>: UIViewRepresentable {
    
    let builder: () -> V
    
    init(builder: @escaping () -> V) {
        self.builder = builder
    }
    
    func makeUIView(context: Context) -> some UIView { builder() }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
