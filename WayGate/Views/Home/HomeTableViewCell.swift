//
//  HomeTableViewCell.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    var nft: NFTItem? {
        didSet {
            guard let nft = nft else { return }
            titleLbl.text = nft.title
            descLbl.text = nft.description
                        
            switch nft.status {
            case .DRAFT:
                statusBtn.backgroundColor = .clear
                statusBtn.borderWidth = 2
                statusBtn.borderColor = .primaryRed
                statusBtn.setTitleColor(.primaryRed, for: .normal)
                statusBtn.setTitle("DRAFT", for: .normal)
            case .FAILED, .none:
                statusBtn.backgroundColor = .primaryRed
                statusBtn.borderWidth = 2
                statusBtn.borderColor = .primaryRed
                statusBtn.setTitleColor(.white, for: .normal)
                statusBtn.setTitle("FAILED", for: .normal)
            case .COMPLETED, .PROCESSED:
                statusBtn.backgroundColor = .JungleGreen
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.white, for: .normal)
                statusBtn.setTitle("VIEW", for: .normal)
            case .INPROCESSING:
                statusBtn.backgroundColor = .secondaryButton
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.primaryText, for: .normal)
                statusBtn.setTitle("IN PROCESS", for: .normal)
            }
        }
    }
}
