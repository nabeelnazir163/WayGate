//
//  EmailVerificationSuccessVCViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class EmailVerificationSuccessVCViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- UI Actions
    @IBAction func didTapContinue(_ sender: Any) {
        if let vc: LoginViewController = UIStoryboard.initiate(storyboard: .auth) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
