//
//  DraftPopupViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 22/09/2023.
//

import UIKit

protocol DraftPopupViewControllerProtocol: AnyObject {
    func NFTCreated(with nft: NFTItem)
}

extension DraftPopupViewControllerProtocol where Self : UIViewController {
    func NFTCreated(with nft: NFTItem) {
        let tabbarVCs = tabBarController?.viewControllers ?? []
        for vc in tabbarVCs {
            if let vc = vc as? HomeViewController {
                vc.nfts.insert(nft, at: 0)
                vc.homeTV.reloadData()
                break
            }
        }
    }
}

class DraftPopupViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var delegate: DraftPopupViewControllerProtocol?
    
    private var enableButton: Bool = false {
        didSet {
            createBtn.isUserInteractionEnabled = enableButton
            createBtn.setTitleColor(enableButton ? .theme : .systemGray2, for: .normal)
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enableButton = false
        titleTF.delegate = self
        addObserver()
        hideKeyboardWhenTappedAround()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint.constant = keyboardHeight - 50
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = -30
    }
    
    //MARK:- UI Actions
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapCreateBtn(_ sender: Any) {
        createNFT()
        
    }
    
    //MARK:- API Handler
    private func createNFT() {
        Commons.showActivityIndicator()
        WebServicesManager.shared.createNFT(title: titleTF.text) { [weak self] result in
            guard let `self` = self else { return }
            Commons.hideActivityIndicator()
            
            switch result {
            case .success(let response):
                if let data = response.dataObject {
                    self.dismiss(animated: true) {
                        self.delegate?.NFTCreated(with: data)
                    }
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
}

extension DraftPopupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            enableButton = false
        } else {
            enableButton = true
        }
    }
}
