//
//  CameraSettingsViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 09/06/2023.
//

import UIKit
import MultiProgressView

enum ModelQuality: String {
    case high = "0", medium = "1", low = "2"
}

enum TextureQuality: String {
    case high = "0", medium = "1", low = "2"
}

enum FileFormatType: String {
    case OBJ, FBX,STL, GLB, GLTF, USDZ, PLY, XYZ
}

class CameraSettingsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var modelHighBtn: UIButton!
    @IBOutlet weak var modelMediumBtn: UIButton!
    @IBOutlet weak var modelLowBtn: UIButton!
    
    @IBOutlet weak var textureHighBtn: UIButton!
    @IBOutlet weak var textureMediumBtn: UIButton!
    @IBOutlet weak var textureLowBtn: UIButton!
    
    @IBOutlet weak var OBJFileFormatBtn: UIButton!
    @IBOutlet weak var FBXFileFormatBtn: UIButton!
    @IBOutlet weak var STLFileFormatBtn: UIButton!
    @IBOutlet weak var GLBFileFormatBtn: UIButton!
    @IBOutlet weak var GLTFFileFormatBtn: UIButton!
    @IBOutlet weak var USDZFileFormatBtn: UIButton!
    @IBOutlet weak var PLYFileFormatBtn: UIButton!
    @IBOutlet weak var XYZFileFormatBtn: UIButton!
    
    @IBOutlet weak var aiMaskBtn: UISwitch!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var progressView: MultiProgressView!
    @IBOutlet weak var uploadLbl: UILabel!
    
    //MARK:- Constants and Variables
    var modelQuality: ModelQuality = .medium {
        didSet {
            modelHighBtn.backgroundColor = modelQuality == .high ? .theme : .clear
            modelMediumBtn.backgroundColor = modelQuality == .medium ? .theme : .clear
            modelLowBtn.backgroundColor = modelQuality == .low ? .theme : .clear
            
            modelHighBtn.setTitleColor(modelQuality == .high ? .primaryText : .secondaryButton, for: .normal)
            modelMediumBtn.setTitleColor(modelQuality == .medium ? .primaryText : .secondaryButton, for: .normal)
            modelLowBtn.setTitleColor(modelQuality == .low ? .primaryText : .secondaryButton, for: .normal)
        }
    }
    var textureQuality: TextureQuality = .medium {
        didSet {
            textureHighBtn.backgroundColor = textureQuality == .high ? .theme : .clear
            textureMediumBtn.backgroundColor = textureQuality == .medium ? .theme : .clear
            textureLowBtn.backgroundColor = textureQuality == .low ? .theme : .clear
            
            textureHighBtn.setTitleColor(textureQuality == .high ? .primaryText : .secondaryButton, for: .normal)
            textureMediumBtn.setTitleColor(textureQuality == .medium ? .primaryText : .secondaryButton, for: .normal)
            textureLowBtn.setTitleColor(textureQuality == .low ? .primaryText : .secondaryButton, for: .normal)
        }
    }
    var fileFormat: FileFormatType = .OBJ {
        didSet {
            OBJFileFormatBtn.backgroundColor = fileFormat == .OBJ ? .theme : .OneA
            FBXFileFormatBtn.backgroundColor = fileFormat == .FBX ? .theme : .OneA
            STLFileFormatBtn.backgroundColor = fileFormat == .STL ? .theme : .OneA
            GLBFileFormatBtn.backgroundColor = fileFormat == .GLB ? .theme : .OneA
            GLTFFileFormatBtn.backgroundColor = fileFormat == .GLTF ? .theme : .OneA
            USDZFileFormatBtn.backgroundColor = fileFormat == .USDZ ? .theme : .OneA
            PLYFileFormatBtn.backgroundColor = fileFormat == .PLY ? .theme : .OneA
            XYZFileFormatBtn.backgroundColor = fileFormat == .XYZ ? .theme : .OneA
            
            OBJFileFormatBtn.setTitleColor(fileFormat == .OBJ ? .primaryText : .secondaryButton, for: .normal)
            FBXFileFormatBtn.setTitleColor(fileFormat == .FBX ? .primaryText : .secondaryButton, for: .normal)
            STLFileFormatBtn.setTitleColor(fileFormat == .STL ? .primaryText : .secondaryButton, for: .normal)
            GLBFileFormatBtn.setTitleColor(fileFormat == .GLB ? .primaryText : .secondaryButton, for: .normal)
            GLTFFileFormatBtn.setTitleColor(fileFormat == .GLTF ? .primaryText : .secondaryButton, for: .normal)
            USDZFileFormatBtn.setTitleColor(fileFormat == .USDZ ? .primaryText : .secondaryButton, for: .normal)
            PLYFileFormatBtn.setTitleColor(fileFormat == .PLY ? .primaryText : .secondaryButton, for: .normal)
            XYZFileFormatBtn.setTitleColor(fileFormat == .XYZ ? .primaryText : .secondaryButton, for: .normal)
            
        }
    }
    
    var nftId: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyGradient()
        modelQuality = .high
        textureQuality = .high
        fileFormat = .OBJ
        loaderView.isHidden = true
        progressView.delegate = self
        progressView.dataSource = self
    }
    
    private func uploadImagesToKiriServer() {
        var params = [String: Any]()
        params["modelQuality"] = modelQuality.rawValue
        params["textureQuality"] = textureQuality.rawValue
        params["ifMask"] = aiMaskBtn.isOn ? "1" : "0"
        let images = Commons.getImagesFromDirectory()
        loaderView.isHidden = false
        WebServicesManager.shared.uploadImagesToKiri(images: images,
                                                     params: params,
                                                     progressCallback: { prog in
            let progress = Int(prog * 100)
            self.uploadLbl.text = "Uploading \(progress)%"
            self.progressView.setProgress(section: 0, to: Float(prog))
        }) { result in
            Commons.hideActivityIndicator()
            self.loaderView.isHidden = true
            switch result {
            case .success(let response):
                if let data = response.dataObject {
                    Constants.serializeToken = data
                    self.updateNFTStatus()
                } else {
                    self.loaderView.isHidden = true
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                self.loaderView.isHidden = true
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    private func updateNFTStatus() {
        Commons.showActivityIndicator()
        WebServicesManager.shared.updateNFtStatus(nftId: nftId, id: Constants.serializeToken, selectedFileFormat: fileFormat.rawValue, media_type: "image") { result in
            Commons.hideActivityIndicator()
            switch result {
            case .success(let response):
                if response.status == 200 {
                    Commons.goToMain()
                } else {
                    self.loaderView.isHidden = true
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                self.loaderView.isHidden = true
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapModelQuality(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            modelQuality = .high
        case 1:
            modelQuality = .medium
        case 2:
            modelQuality = .low
        default:
            modelQuality = .medium
        }
    }
    
    @IBAction func didTapTextureQuality(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            textureQuality = .high
        case 1:
            textureQuality = .medium
        case 2:
            textureQuality = .low
        default:
            textureQuality = .medium
        }
    }
    
    @IBAction func didTapFileFormat(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            fileFormat = .OBJ
        case 1:
            fileFormat = .FBX
        case 2:
            fileFormat = .STL
        case 3:
            fileFormat = .GLB
        case 4:
            fileFormat = .GLTF
        case 5:
            fileFormat = .USDZ
        case 6:
            fileFormat = .PLY
        case 7:
            fileFormat = .XYZ
        default:
            fileFormat = .OBJ
        }
    }
    
    @IBAction func didTapUpload(_ sender: Any) {
        loaderView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.uploadImagesToKiriServer()
        }
    }
}

extension CameraSettingsViewController: MultiProgressViewDelegate, MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        1
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        switch section {
        case 0:
            sectionView.backgroundColor = .green
        default:
            break
        }
        return sectionView
    }
}
