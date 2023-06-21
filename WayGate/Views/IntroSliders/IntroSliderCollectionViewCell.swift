//
//  IntroSliderCollectionViewCell.swift
//  WayGate
//
//  Created by Nabeel Nazir on 21/06/2023.
//

import UIKit

class IntroSliderCollectionViewCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageLbl: UIImageView!
    
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex == 0 {
                titleLbl.text = "Start with an object"
                backgroundColor = .introGray
            } else if currentIndex == 1 {
                titleLbl.text = "Capture crisp images"
                backgroundColor = .introBlue
            } else {
                titleLbl.text = "Get all angles"
                backgroundColor = .introPink
            }
            imageLbl.image = UIImage(named: "Slider\(currentIndex)")
        }
    }
}
