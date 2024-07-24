//
//  IntroSliderViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 21/06/2023.
//

import UIKit

class IntroSliderViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var getStartedBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyGradient()
        setupCollectionView()
        view.layoutIfNeeded()
        collectionView.layoutIfNeeded()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: IntroSliderCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: IntroSliderCollectionViewCell.className)
    }
    
    //MARK:- UI Actions
    @IBAction func didTapGetStarted(_ sender: Any) {
        UserDefaultsConfig.isFirstLaunch = false
        Commons.goToLogin()
    }
}

extension IntroSliderViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroSliderCollectionViewCell.className, for: indexPath) as? IntroSliderCollectionViewCell else {
            return IntroSliderCollectionViewCell()
        }
        cell.currentIndex = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController.currentPage = collectionView.currentPage
        getStartedBtn.isHidden = collectionView.currentPage != 2
        pageController.isHidden = !getStartedBtn.isHidden
    }
}
