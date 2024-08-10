//
//  SettingsViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyGradient()
    }
    
    //MARK:- UI Actions
    @IBAction func didTapPrivacyBtn(_ sender: Any) {
        let url = URL(string: Constants.privacyPolicyURL)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapTermsBtn(_ sender: Any) {
        let url = URL(string: Constants.termsAndConditionURL)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        if let vc: LogoutPopupViewController = UIStoryboard.initiate(storyboard: .main) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
}
