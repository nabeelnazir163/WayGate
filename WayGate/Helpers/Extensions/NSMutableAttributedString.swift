//
//  NSMutableAttributedString.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize: CGFloat { return 14 }
    var boldFont :UIFont { return UIFont.JakartaSansBold?.withSize(fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont.JakartaSansRegular?.withSize(fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    public func bold(_ value:String, color: UIColor? = .theme) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: boldFont,
            .foregroundColor: color ?? .black
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    public func normal(_ value: String, color: UIColor? = nil) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
            .foregroundColor: color ?? .black
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    public func underlined(_ value: String, color: UIColor? = nil) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor: color ?? .black,
            .underlineStyle : NSUnderlineStyle.single.rawValue
                
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    public func strikeThrough(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.darkGray,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
