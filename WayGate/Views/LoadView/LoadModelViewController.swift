//
//  LoadModelViewController.swift
//  WayGate
//
//  Created by Nabeel Nazir on 04/12/2024.
//

import UIKit
import SceneKit
import QuickLook

class LoadModelViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

    var nftItem: NFTItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadUSdzFile()
    }
    
    private func downloadUSdzFile() {
        guard let urlString = nftItem?.objectCaptureLink,
              let remoteURL = URL(string: urlString) else {
            return
        }
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("modelobject.usdz")
        
        Commons.showActivityIndicator()
        downloadFile(with: remoteURL) { [weak self] objURL, isDownloaded in
            Commons.hideActivityIndicator()
            guard let self else { return }
            if isDownloaded, let objURL = objURL {
                do {
                    try FileManager.default.copyItem(at: objURL, to: destinationFileUrl)
                    loadModel(with: destinationFileUrl)
                } catch (let writeError) {
                    Commons.showAlert(msg: "Something went wrong, Try again later")
                }
            } else {
                Commons.showAlert(msg: "Something went wrong, Try again later")
            }
        }
    }
    
    private func downloadFile(with url: URL, completion: @escaping (URL?, Bool)-> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            DispatchQueue.main.async {
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        completion(tempLocalUrl, true)
                    } else {
                        completion(nil, false)
                    }
                } else {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
    
    private func loadModel(with url: URL) {
        do {
            let scene = try SCNScene(url: url)
            
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni
            lightNode.position = SCNVector3(0, 10, 35)
            scene.rootNode.addChildNode(lightNode)
            
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light?.type = .spot
            ambientLightNode.light?.color = UIColor.darkGray
            scene.rootNode.addChildNode(ambientLightNode)
            
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            sceneView.backgroundColor = .white
            sceneView.cameraControlConfiguration.allowsTranslation = false
            
            sceneView.scene = scene
        } catch {
            
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
