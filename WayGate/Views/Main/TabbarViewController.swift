//
//  TabbarViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class TabbarViewController: UITabBarController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let emptyVC = viewController as? EmptyTabbarViewController {
            if let vc: DraftPopupViewController = UIStoryboard.initiateWithBundle(storyboard: .main) {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = emptyVC
                present(vc, animated: true)
            }
            return false
        }
        return true
    }
}
