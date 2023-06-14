//
//  3DModelDisplay.swift
//  WayGate
//
//  Created by Nabeel Nazir on 12/06/2023.
//

import SwiftUI
import Model3DKit

struct ModelDisplay: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let sceneView = SceneView(frame: .zero)
    
    var nftItem: NFTItem?
    var dismissAction: (() -> Void)
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            UIViewPreview {
                sceneView
            }
            VStack(alignment: .trailing) {
                Button {
                    dismissAction()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(Color.gray)
                        .frame(width: 24, height: 24)
                }
            }.padding(20)
        }
        .padding()
        .onAppear {
            downloadObjFile()
        }
    }
    
    private func downloadObjFile() {
        guard let objItem = nftItem?.threeDfile?.first(where: { $0.fileName == "3DModel.obj" }),
              let objUrlString = objItem.s3Url,
              let objUrl = URL(string: objUrlString) else { return }
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("modelobject.obj")
        
        downloadFile(with: objUrl) { objURL, isDownloaded in
            if isDownloaded, let objURL = objURL {
                do {
                    try FileManager.default.copyItem(at: objURL, to: destinationFileUrl)
                    downloadJPGFile(objUrl: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            }
        }
    }
    
    private func downloadJPGFile(objUrl: URL) {
        guard let jpgItem = nftItem?.threeDfile?.first(where: { $0.fileName == "3DModel.jpg" }),
              let jpgUrlString = jpgItem.s3Url,
              let jpgUrl = URL(string: jpgUrlString) else { return }
        
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("modeljpg.jpg")
        
        downloadFile(with: jpgUrl) { jpgURL, isDownloaded in
            if isDownloaded, let jpgURL = jpgURL {
                do {
                    try FileManager.default.copyItem(at: jpgURL, to: destinationFileUrl)
                    sceneView.loadScene(modelUrl: objUrl, textureUrl: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            }
        }
    }
    
    private func downloadFile(with url: URL, completion: @escaping (URL?, Bool)-> Void) {
        Commons.showActivityIndicator()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            DispatchQueue.main.async {
                Commons.hideActivityIndicator()
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        completion(tempLocalUrl, true)
                    } else {
                        completion(nil, false)
                    }
                } else {
                    print(error?.localizedDescription)
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
}

struct ModelDisplay_Previews: PreviewProvider {
    static var previews: some View {
        ModelDisplay(dismissAction: {})
    }
}
