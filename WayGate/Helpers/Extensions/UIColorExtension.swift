//
//  UIColorExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit
import SwiftUI

extension UIColor {
    public static let theme = UIColor(named: "Theme")!
    public static let secondaryButton = UIColor(named: "SecondaryButton")!
    public static let secondaryText = UIColor(named: "SecondaryText")!
    static let primaryText = UIColor(named: "PrimaryText")!
    static let border = UIColor(named: "Border")!
    static let JungleGreen = UIColor(named: "JungleGreen")!
    static let primaryRed = UIColor(named: "PrimaryRed")!
    static let introGray = UIColor(named: "IntroGray")!
    static let placeHolderColor = UIColor(named: "PlaceHolderColor")!
    static let grayColor = UIColor(named: "GrayColor")!
    static let BGColor = UIColor(named: "BGColor")!
    static let OneA = UIColor(named: "1A1A1A")!
    static let gradientColors = [UIColor(named: "GradientStartColor")!.cgColor,
                                 UIColor(named: "GradientEndColor")!.cgColor]
}

extension Color {
    static let blackBG = Color("BlackBG")
    static let primaryRed = Color("PrimaryRed")
    static let JungleGreen = Color("JungleGreen")
    static let theme = Color("Theme")
}
