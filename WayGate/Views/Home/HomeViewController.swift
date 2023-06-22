//
//  HomeViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import KiriAdvanceCameraKit
import SwiftUI

class HomeViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var descriptiveStackView: UIStackView!
    @IBOutlet weak var noDraftView: UIStackView!
    
    //MARK:- Constants
    private var nfts: [NFTItem] = [NFTItem]() {
        didSet {
            noDraftView.isHidden = !nfts.isEmpty
            descriptiveStackView.isHidden = nfts.isEmpty
            homeTV.reloadData()
        }
    }

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        noDraftView.isHidden = true
        descriptiveStackView.isHidden = true
        Commons.deleteDirectory(name: "/CameraKit/")
        setupUI()
        getNFTs()
        homeTV.setUpRefresherControll(tintColor: .theme) { [weak self] in
            guard let `self` = self else { return }
            self.getNFTs(showLoader: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Commons.deleteDirectory(name: "modelobject.obj")
        Commons.deleteDirectory(name: "modeljpg.jpg")
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        homeTV.delegate = self
        homeTV.dataSource = self
        
        homeTV.register(UINib(nibName: HomeTableViewCell.className,
                              bundle: nil),
                        forCellReuseIdentifier: HomeTableViewCell.className)
    }
    
    //MARK:- API Call
    private func getNFTs(showLoader: Bool = true) {
        if showLoader {
            Commons.showActivityIndicator()
        }
        WebServicesManager.shared.getHomeNFTs { [weak self] result in
            Commons.hideActivityIndicator()
            guard let `self` = self else { return }
            self.homeTV.stopRefresher()
            switch result {
            case .success(let baseResponse):
                if let nftsList = baseResponse.dataObject?.nfts {
                    self.nfts = nftsList
                } else {
                    Commons.showAlert(msg: baseResponse.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.className, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nft = nfts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = nfts[indexPath.row]
        if item.status == .DRAFT {
            openCamera(item: item)
        } else if item.status == .PROCESSED {
            open3DModel(item: item)
        } else if item.status == .INPROCESSING {
            Commons.showAlert(msg: "Please wait, Your 3D model is in process")
        }
    }
    
    private func openCamera(item: NFTItem?) {
        let camera = CameraAdvance(nftItem: item, dismissAction: {
            self.dismiss( animated: true, completion: nil )
        })
        let vc = UIHostingController(rootView: camera)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    private func open3DModel(item: NFTItem?) {
        let camera = ModelDisplay(nftItem: item, dismissAction: {
            self.viewWillAppear(false)
            self.dismiss( animated: true, completion: nil )
        })
        let vc = UIHostingController(rootView: camera)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
