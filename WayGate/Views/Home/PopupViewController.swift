//
//  PopupViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 04/08/2023.
//

import UIKit
protocol PopupViewControllerDelegate: AnyObject {
    func didSelectPhotos(item: NFTItem)
    func didSelectVideo(item: NFTItem)
}

class PopupViewController: UIViewController {
    
    //MARK:- Properties
    weak var delegte: PopupViewControllerDelegate?
    var item: NFTItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- UIACtions
    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func didTapPhotoSelection(_ sender: Any) {
        guard let item else { return }
        dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.delegte?.didSelectPhotos(item: item)
        }
    }
    
    @IBAction func didTapVideoSelection(_ sender: Any) {
        guard let item else { return }
        dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.delegte?.didSelectVideo(item: item)
        }
    }
}
