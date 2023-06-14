//
//  UIStoryboardExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

extension UIStoryboard {
    class func initial<T: UIViewController>(storyboard: StoryboardEnum) -> T {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as! T
    }

    static func initiate<T: UIViewController>(storyboard: StoryboardEnum) -> T?{
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.className) as? T
    }

    func initiate<T: UIViewController>()->T{
        return instantiateViewController(withIdentifier: T.className) as! T
    }

    static func initiateWithBundle<T: UIViewController>(storyboard: StoryboardEnum) -> T?{
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.className) as? T
    }

    enum StoryboardEnum: String {
        case auth = "Auth"
        case main = "Main"
        case camera = "Camera"
    }
}
