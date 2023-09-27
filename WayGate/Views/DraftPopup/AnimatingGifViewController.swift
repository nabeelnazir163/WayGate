//
//  AnimatingGifViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 26/09/2023.
//

import UIKit
import Lottie

enum AssetType {
    case image, video
}

protocol AnimatingGifViewControllerProtocol: AnyObject {
    func createAsset(for type: AssetType, item: NFTItem)
}

class AnimatingGifViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    
    weak var delegate: AnimatingGifViewControllerProtocol?
    var assetType: AssetType = .image
    var nftItem: NFTItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.startAnimatingGIF()
        }
        
        if assetType == .image {
            descLbl.text = "Scan the object by taking photos around it in 360°, capturing all angles."
        } else {
            descLbl.text = "Scan the object by recording video around it in 360°, capturing all angles."
        }
    }
    
    private func startAnimatingGIF() -> Void {
        let animationView: LottieAnimationView = .init(name: "AnimateView")
        gifImageView.addSubview(animationView)
                
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: gifImageView.topAnchor, constant: -40).isActive = true
        animationView.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 40).isActive = true
        animationView.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor, constant: -40).isActive = true
        animationView.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 40).isActive = true
        
        animationView.loopMode = .loop
        animationView.play()
    }
    
    //MARK:- UI Actions
    @IBAction func didTapCreateAsset(_ sender: Any) {
        if let nftItem {
            dismiss(animated: true) {
                self.delegate?.createAsset(for: self.assetType, item: nftItem)
            }
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}
