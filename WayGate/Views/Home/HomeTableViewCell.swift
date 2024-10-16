//
//  HomeTableViewCell.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

protocol HomeTableViewCellProtocol: AnyObject {
    func didTapDeleteItem(item: NFTItem?)
}

class HomeTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var settingsBtn: UIButton!
    
    weak var delegate: HomeTableViewCellProtocol?
    
    var nft: NFTItem? {
        didSet {
            guard let nft = nft else { return }
            titleLbl.text = nft.title
            descLbl.text = nft.description
            settingsBtn.isHidden = false
            switch nft.status {
            case .DRAFT:
                statusBtn.backgroundColor = .clear
                statusBtn.borderWidth = 1
                statusBtn.borderColor = .theme
                statusBtn.setTitleColor(.theme, for: .normal)
                statusBtn.setTitle("Draft", for: .normal)
            case .FAILED, .none:
                statusBtn.backgroundColor = .primaryRed
                statusBtn.borderWidth = 2
                statusBtn.borderColor = .primaryRed
                statusBtn.setTitleColor(.white, for: .normal)
                statusBtn.setTitle("Failed", for: .normal)
            case .COMPLETED, .PROCESSED:
                statusBtn.backgroundColor = .JungleGreen
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.white, for: .normal)
                statusBtn.setTitle("View", for: .normal)
            case .INPROCESSING:
                statusBtn.backgroundColor = .grayColor
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.white, for: .normal)
                statusBtn.setTitle("In Progress", for: .normal)
                settingsBtn.isHidden = true
            }
        }
    }
    
    @IBAction func didTapSettings(_ sender: Any) {
        delegate?.didTapDeleteItem(item: nft)
    }
}
