//
//  UIFontExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit
import SwiftUI

extension UIFont{
    public static var JakartaSansRegular: UIFont?{
        return UIFont(name: "PlusJakartaSans-Regular", size: 10)
    }
    
    public static var JakartaSansBold: UIFont?{
        return UIFont(name: "PlusJakartaSans-Bold", size: 10)
    }
    
    public static var JakartaSansMedium: UIFont?{
        return UIFont(name: "PlusJakartaSans-Medium", size: 10)
    }
    
    public static var JakartaSansLight: UIFont?{
        return UIFont(name: "PlusJakartaSans-Light", size: 10)
    }
}


extension Font {
    static func JakartaSansRegular(with size: Double) -> Font{
        Font.custom("PlusJakartaSans-Light", size: size)
    }
    
    static func JakartaSansBold(with size: Double) -> Font{
        return Font.custom("PlusJakartaSans-Bold", size: size)
    }
    
    static func JakartaSansMedium(with size: Double) -> Font{
        return Font.custom("PlusJakartaSans-Medium", size: size)
    }
    
    static func JakartaSansLight(with size: Double) -> Font{
        return Font.custom("PlusJakartaSans-Light", size: size)
    }
}
