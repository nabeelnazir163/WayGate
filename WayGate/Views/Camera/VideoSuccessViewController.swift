//
//  VideoSuccessViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 05/08/2023.
//

import UIKit
import KIRIEngineSDK

class VideoSuccessViewController: UIViewController {

    var result: KIRIEngineSDK.VideoParameter?
    var fileURL: URL?
    var nftId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func uploadVideoToKiri() {
        guard let data = getDataFromUrl() else { return }
        var params = [String: Any]()
        params["length"] = "\(result?.length ?? 0)"
        params["resolution"] = result?.resolution
        params["md5"] = result?.specialKey
        Commons.showActivityIndicator()
        WebServicesManager.shared.uploadVideoToKiri(video: data, params: params) { [weak self] result in
            Commons.hideActivityIndicator()
            guard let `self` = self else { return }
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
        uploadVideoToKiri()
    }
    
    @IBAction func didTapRetry(_ sender: Any) {
        dismiss(animated: true)
    }
}
