//
//  LogoutPopupViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class LogoutPopupViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- UI Actions
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapConfirm(_ sender: Any) {
        Commons.goToLogin()
    }
}
