//
//  LoginViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var termsAndConditionLabel: UILabel!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        hideKeyboardWhenTappedAround()
        loginBtn.setButton(enabled: false)
    }
    
    private func setupUI (){
        setupAttributedLabel()
        setupTextField()
    }
    
    private func setupTextField() {
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    private func setupAttributedLabel() {
        termsAndConditionLabel.attributedText = NSMutableAttributedString()
            .normal("By using this app, you agree to ")
            .bold("Waygate Terms of service")
            .normal(" and ")
            .bold("Privacy policy")
            .normal(".")
    }
    
    //MARK:- API URL
    private func loginUser(with email: String, password: String) {
        Commons.showActivityIndicator()
        WebServicesManager.shared.loginUser(with: email, password: password) { result in
            Commons.hideActivityIndicator()
            switch result {
            case .success(let response):
                if let user = response.dataObject {
                    UserDefaultsConfig.user = user
                    Commons.goToMain()
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapLoginBtn(_ sender: Any) {
        loginUser(with: emailTF.text!, password: passwordTF.text!)
    }
    
    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        if let vc: ForgotPasswordViewController = UIStoryboard.initiate(storyboard: .auth) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
    
    @IBAction func didTapPasswordEye(_ sender: Any) {
        passwordTF.isSecureTextEntry.toggle()
    }
}

//MARK:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTF.text?.isEmpty ?? true {
            print("Enter Password")
            loginBtn.setButton(enabled: false)
            return
        }
        
        if emailTF.text?.isEmpty ?? true {
            print("Enter Email")
            loginBtn.setButton(enabled: false)
            return
        }
        
        guard let email = emailTF.text,
              email.isEmail else {
            print("Enter Valid Email")
            loginBtn.setButton(enabled: false)
            return
        }
        
        loginBtn.setButton(enabled: true)
    }
}
