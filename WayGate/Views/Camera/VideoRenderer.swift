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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    let vc = VideoCaptureVC()!
    let proxy = VideoCaptureProxy()
    @State
    var isPresented = false
    @State
    var fileURL: URL?
    var nftId: String?
    var dismissAction: (() -> Void)
    
    init(nftId: String?,
         dismissAction: @escaping () -> Void) {
        vc.delegate = proxy
        self.nftId = nftId
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            UIViewControllerPreview {
                vc
            }
            
            Button {
                dismissAction()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundColor(Color.white)
                    .padding(8)
                    .frame(width: 40, height: 40)
            }
            .padding(.top, safeAreaInsets.top + 20)
            .padding(.trailing, 20)
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
                    checkVideo()
                } else {
                    Commons.showAlert(msg: response.message ?? "")
                }
            case .failed(let error):
                Commons.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    func checkVideo() {
        guard let url = self.fileURL else { return }
        Commons.showActivityIndicator()
        VideoTools.checkVideoFile(url) { result in
            DispatchQueue.main.async {
                Commons.hideActivityIndicator()
                switch result {
                case .success(let response):
                    openViewController(result: response)
                case .failure(let error):
                    print("error:\(error)")
                }
            }
        }
    }
    
    private func openViewController(result: KIRIEngineSDK.VideoParameter) {
        if let vc: VideoSuccessViewController = UIStoryboard.initiate(storyboard: .camera) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.result = result
            vc.fileURL = fileURL
            vc.nftId = nftId
            UIApplication.topViewController()?.present(vc, animated: true)
        }
    }
}

