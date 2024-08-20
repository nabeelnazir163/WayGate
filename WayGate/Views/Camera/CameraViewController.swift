//
//  CameraViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 03/06/2023.
//

import UIKit
import AVFoundation
import KIRIEngineSDK
class CameraViewController: UIViewController {
    
    private var cameraView = CameraView()

    private var imagesList = [Data]()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        addCameraView()
        setDocumentPath()
        previewCamera()
    }
    
    private func addCameraView() {
        view.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.sendSubviewToBack(cameraView)        
    }
    
    private func setDocumentPath() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        cameraView.setPhotoFolderPath("\(docPath)/CameraKit")
    }
    
    
    private func previewCamera() {
        cameraView.startPreview { result in
            switch result {
            case .success(let resp):
                print("Auth Status:", resp.rawValue)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapCrossBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapTakePhoto(_ sender: Any) {
        cameraView.takePhoto()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let img = UIImage(data: data) {
            print(img)
        }
    }
}
