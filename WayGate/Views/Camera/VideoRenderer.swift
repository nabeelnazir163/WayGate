//
//  VideoCaptureContentView.swift
//  WayGate
//
//  Created by Nabeel Nazir on 05/08/2023.
//


import SwiftUI
import KIRIEngineSDK
import AVKit
import UIKit

class VideoCaptureProxy: VideoCaptureVCDelegate {
    
    var finishRecordingClosure: ((URL, Error?) -> Void)?
    
    init() { }
     
    func videoCapture(_ vc: KIRIEngineSDK.VideoCaptureVC, didFinishRecording outputFileURL: URL, error: Error?) {
        finishRecordingClosure?(outputFileURL, error)
    }
    
}

struct VideoCaptureContentView: View {
    let vc = VideoCaptureVC()!
    let proxy = VideoCaptureProxy()
    @State
    var isPresented = false
    @State
    var fileURL: URL?
    
    init() {
        vc.delegate = proxy
    }
    
    var body: some View {
        VStack {
            UIViewControllerPreview {
                vc
            }
        }
        .onAppear {
            proxy.finishRecordingClosure = { fileURL, error in
                DispatchQueue.main.async {
                    self.fileURL = fileURL
                    self.getToken()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func getToken() {
        Commons.showActivityIndicator()
        WebServicesManager.shared.getToken { result in
            Commons.hideActivityIndicator()
            switch result {
            case .success(let response):
                if let token = response.dataObject {
                    Constants.token = token
                    openViewController()
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    private func openViewController() {
        if let vc: VideoSuccessViewController = UIStoryboard.initiate(storyboard: .camera) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            UIApplication.topViewController()?.present(vc, animated: true)
        }
    }
}

struct VideoCaptureContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoCaptureContentView()
    }
}

public struct UIViewControllerPreview<VC: UIViewController>: UIViewControllerRepresentable {

  public let builder: () -> VC

  public init(builder: @escaping () -> VC) {
    self.builder = builder
  }

  public func makeUIViewController(context: Context) -> VC { builder() }
  public func updateUIViewController(_ uiViewController: VC, context: Context) {}
}
