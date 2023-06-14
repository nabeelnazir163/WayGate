//
//  ForgotPasswordViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- UI Actions
    @IBAction func didTapLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        if let vc: EmailVerificationSuccessVCViewController = UIStoryboard.initiate(storyboard: .auth) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
}
