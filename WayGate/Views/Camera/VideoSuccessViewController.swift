//
//  VideoSuccessViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 05/08/2023.
//

import UIKit
import MultiProgressView
import KIRIEngineSDK

class VideoSuccessViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var uploadLbl: UILabel!
    @IBOutlet weak var progressView: MultiProgressView!

    var result: KIRIEngineSDK.VideoParameter?
    var fileURL: URL?
    var nftId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = true
        progressView.delegate = self
        progressView.dataSource = self
    }
    
    private func uploadVideoToKiri() {
        guard let data = getDataFromUrl() else { return }
        var params = [String: Any]()
        params["length"] = "\(result?.length ?? 0)"
        params["resolution"] = result?.resolution
        params["md5"] = result?.specialKey
        loaderView.isHidden = false
        WebServicesManager.shared.uploadVideoToKiri(video: data, params: params) { prog in
            let progress = Int(prog * 100)
            self.uploadLbl.text = "Uploading \(progress)%"
            self.progressView.setProgress(section: 0, to: Float(prog))
        } callBack: { [weak self] result in
            guard let `self` = self else { return }
            self.loaderView.isHidden = true
            switch result {
            case .success(let baseResponse):
                if let data = baseResponse.dataObject {
                    Constants.serializeToken = data
                    self.updateNFTStatus()
                } else {
                    Commons.showAlert(msg: baseResponse.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    private func updateNFTStatus() {
        Commons.showActivityIndicator()
        WebServicesManager.shared.updateNFtStatus(nftId: nftId, id: Constants.serializeToken, selectedFileFormat: FileFormatType.OBJ.rawValue, media_type: "video") { result in
            Commons.hideActivityIndicator()
            switch result {
            case .success(let response):
                if response.status == 200 {
                    Commons.goToMain()
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }

    private func getDataFromUrl() -> Data? {
        guard let fileURL else { return nil }
        do {
            return try Data(contentsOf: fileURL, options: .dataReadingMapped)
        } catch {
            print(error)
            return nil
        }
    }
    
    //MARK:- UI ACtions
    @IBAction func didTapUploadNow(_ sender: Any) {
        loaderView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.uploadVideoToKiri()
        }
    }
    
    @IBAction func didTapRetry(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension VideoSuccessViewController: MultiProgressViewDelegate, MultiProgressViewDataSource {
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
