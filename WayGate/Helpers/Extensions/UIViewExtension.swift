//
//  UIViewExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 01/06/2023.
//

import UIKit

public enum SepPositions {
    case top, bottom
}

extension UIView {
    public func parentViewController() -> UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}

extension UIView {
    
    public func layoutIfNeededWithAnimation(duration: TimeInterval?){
        UIView.animate(withDuration: duration ?? 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    public func getConstriant(identifier: String) -> NSLayoutConstraint?{
        for constraint in self.constraints {
            if constraint.identifier == identifier{
                return constraint
            }
        }
        return nil
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable public  var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var circle: Bool{
        get{
            return false
        }
        set{
            if newValue{
                layer.cornerRadius = frame.width*0.5
                layer.masksToBounds = true
            }
            
        }
    }
    
    // MARK: - Shadow
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    public func fadeIn(duration: TimeInterval = 0.3, isWithInStackView: Bool = false){
        guard isWithInStackView else {
        UIView.animate(withDuration: duration) {
            self.alpha = 1
            }
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.isHidden = false
        }
    }
    
    public func fadeOut(duration: TimeInterval = 0.3, isWithInStackView: Bool = false){
        
        guard isWithInStackView else {
            UIView.animate(withDuration: duration) {
                self.alpha = 0
            }
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.isHidden = true
        }
    }
    
    /// Adds shadow to view, sets shadowOpacity to 0.16, set shadowOffer to CGSize(width: 0, height: 3) and radius to 3.
    public func dropShadow(scale: Bool = true , color: CGColor? = UIColor.gray.withAlphaComponent(0.7).cgColor , shadowRadius: CGFloat = 10, shadowOffset: CGSize = CGSize(width: 0, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = 0.9
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    //Responsible to load NibFiles
    public class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    /**
     Adds seperator View at the bottom of view passed as parameter
     */
    public func addSepView(color: UIColor? = UIColor.separator, height: CGFloat = 1, at postion: SepPositions? = .bottom ) {
        let sepView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height))
        self.addSubview(sepView)
        
        sepView.backgroundColor = color
        
        sepView.translatesAutoresizingMaskIntoConstraints = false
        sepView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        sepView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        if postion == .top {
            sepView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        } else if postion == .bottom {
            sepView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        }
        sepView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func roundTopCorners(radius: CGFloat? = 10) {
        resetCorners()
        clipsToBounds = true
        layer.cornerRadius = radius ?? 10
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    public func roundTopRightCorner(radius: CGFloat? = 10) {
        resetCorners()
        clipsToBounds = true
        layer.cornerRadius = radius ?? 10
        layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    public func roundBottomCorners(cornerRadius: CGFloat = 10) {
        resetCorners()
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    public func roundAllCorners() {
        resetCorners()
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    public func resetCorners() {
        clipsToBounds = false
        layer.cornerRadius = 0
        layer.maskedCorners = []
    }
}
