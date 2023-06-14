//
//  UIFontExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit
import SwiftUI

extension UIFont{
    public static var CircularSTDRegular: UIFont?{
        return UIFont(name: "CircularStd-Book", size: 10)
    }
    
    public static var CircularSTDBold: UIFont?{
        return UIFont(name: "CircularStd-Bold", size: 10)
    }
    
    public static var CircularSTDMedium: UIFont?{
        return UIFont(name: "CircularStd-Medium", size: 10)
    }
    
    public static var CircularSTDLight: UIFont?{
        return UIFont(name: "CircularStd-Light", size: 10)
    }
}


extension Font {
    static func CircularSTDRegular(with size: Double) -> Font{
        Font.custom("CircularStd-Book", size: size)
    }
    
    static func CircularSTDBold(with size: Double) -> Font{
        return Font.custom("CircularStd-Bold", size: size)
    }
    
    static func CircularSTDMedium(with size: Double) -> Font{
        return Font.custom("CircularStd-Medium", size: size)
    }
    
    static func CircularSTDLight(with size: Double) -> Font{
        return Font.custom("CircularStd-Light", size: size)
    }
}
