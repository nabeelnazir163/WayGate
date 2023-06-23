//
//  ForgotPasswordViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
    }
    
    //MARK:- WebServices
    private func forgotPassword() {
        Commons.showActivityIndicator()
        WebServicesManager.shared.forgotPassword(with: emailTF.text) { [weak self] result in
            guard let `self` = self else { return }
            Commons.hideActivityIndicator()
            switch result {
            case .success(let response):
                if response.status == 200 {
                    self.goToSuccessScreen()
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        forgotPassword()
    }
    
    private func goToSuccessScreen() {
        if let vc: EmailVerificationSuccessVCViewController = UIStoryboard.initiate(storyboard: .auth) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
}

//MARK:- UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if emailTF.text?.isEmpty ?? true {
            print("Enter Email")
            resetPasswordBtn.setButton(enabled: false)
            return
        }
        
        guard let email = emailTF.text,
              email.isEmail else {
            print("Enter Valid Email")
            resetPasswordBtn.setButton(enabled: false)
            return
        }
        
        resetPasswordBtn.setButton(enabled: true)
    }
}
