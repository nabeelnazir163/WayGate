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
            
            statusBtn.setTitle(nft.status?.rawValue.lowercased().capitalized, for: .normal)
            
            switch nft.status {
            case .DRAFT, .FAILED:
                statusBtn.backgroundColor = .clear
                statusBtn.borderWidth = 2
                statusBtn.borderColor = .primaryRed
                statusBtn.setTitleColor(.primaryRed, for: .normal)
            case .COMPLETED, .PROCESSED, .none:
                statusBtn.backgroundColor = .JungleGreen
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.white, for: .normal)
                if nft.status == .PROCESSED || nft.status == .COMPLETED {
                    statusBtn.setTitle("View NFT", for: .normal)
                }
            case .INPROCESSING:
                statusBtn.backgroundColor = .secondaryButton
                statusBtn.borderWidth = 0
                statusBtn.setTitleColor(.primaryText, for: .normal)
                statusBtn.setTitle("In Process", for: .normal)
            }
        }
    }
}
