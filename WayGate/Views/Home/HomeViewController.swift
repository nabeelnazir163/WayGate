//
//  HomeViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 02/06/2023.
//

import KiriAdvanceCameraKit
import SwiftUI
import KIRIEngineSDK

class HomeViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var descriptiveStackView: UIStackView!
    @IBOutlet weak var noDraftView: UIStackView!
    
    //MARK:- Constants
    var nfts: [NFTItem] = [NFTItem]() {
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
        
        cell.delegate = self
        cell.nft = nfts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = nfts[indexPath.row]
        if item.status == .DRAFT {
            openPopup(item: item)
        } else if item.status == .PROCESSED {
            open3DModel(item: item)
        } else if item.status == .INPROCESSING {
            Commons.showAlert(msg: "Please wait, your 3D model is in process")
        } else if item.status == .FAILED {
            Commons.showAlert(msg: "The image quality does not meet the minimum requirements. Please retry creating a new model with higher resolution and improved clarity for accurate model rendering.")
        }
    }
    
    private func openPopup(item: NFTItem?) {
        if let vc: PopupViewController = UIStoryboard.initiate(storyboard: .main) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegte = self
            vc.item = item
            present(vc, animated: true)
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

extension HomeViewController: PopupViewControllerDelegate {
    func didSelectVideo(item: NFTItem) {
        Commons.showActivityIndicator()
        KIRISDK.share.setup(envType: .product, appKey: Constants.AppKey) { result in
            DispatchQueue.main.async {
                
                print("result:\(result)")
                Commons.hideActivityIndicator()
                switch result {
                case .success:
                    let camera = VideoCaptureContentView(nftId: item._id, dismissAction: {
                        self.viewWillAppear(false)
                        self.dismiss(animated: true, completion: nil )
                    })
                    let vc = UIHostingController(rootView: camera)
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                case .failure:
                    print("Failed")
                }
            }
        }
    }
    
    func didSelectPhotos(item: NFTItem) {
        openCamera(item: item)
    }
}

extension HomeViewController: HomeTableViewCellProtocol {
    func didTapDeleteItem(item: NFTItem?) {
        guard let item = item else { return }
        
        let alert = UIAlertController(title: "Delete Asset?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: item.status == .DRAFT ? "Remove Draft" : "Remove 3D Model", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
