//
//  CameraAdvance.swift
//  WayGate
//
//  Created by Nabeel Nazir on 03/06/2023.
//

import SwiftUI
import UIKit
import KiriAdvanceCameraKit
import Switches

struct CameraAdvance: View {
    let cameraView = CameraView<AdvanceImageCaptureModel>()
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State var isManualOn = false
    
    @State var isExposureSelected = false
    @State var isISOSelected = false
    @State var isShutterSelected = false
    
    @State var evValue: CGFloat = 0
    @State var isoValue: CGFloat = 300
    @State var shutterValue: CGFloat = 0.03
    
    @State var currentPhotosCount = 0
    
    @State var cameraButtonDisabled = false
    
    let maximumPhotosLimit = 200
    let minimumPhotosLimit = 40
        
    var nftItem: NFTItem?
    var dismissAction: (() -> Void)
    
    var body: some View {
        ZStack() {
            UIViewPreview {
                cameraView
            }
            
            VStack(alignment: .trailing) {
                
                VStack(alignment: .center, spacing: 30) {
                    
                    Button {
                        dismissAction()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color.gray)
                            .frame(width: 24, height: 24)
                    }
                    
                    CustomToggle(isOn: $isManualOn)
                        .frame(width: 40, height: 20)
                        .rotationEffect(Angle(degrees: 90))
                    
                    if isManualOn {
                        manualSettingsView
                    }
                }
                .padding(.top, safeAreaInsets.top + 20)
                .frame(width: 100)
                
                Spacer()
                
                HStack {
                    Text("\(currentPhotosCount)/\(maximumPhotosLimit)")
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.vertical, 10)
                        .frame(width: 80)
                        .background(Color.blackBG)
                        .cornerRadius(8)
                    
                    if currentPhotosCount >= maximumPhotosLimit {
                        Spacer()
                    } else {
                        takePhotoView
                    }
                    
                    if currentPhotosCount >= minimumPhotosLimit {
                        Button {
                            getToken()
                        } label: {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.blackBG)
                                .padding(8)
                                .frame(width: 38, height: 38)
                                .background(Color.white)
                                .cornerRadius(19)
                                .frame(width: 80)
                        }
                    } else {
                        Spacer()
                            .frame(width: 80, height: 38)
                    }
                    
                }.padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 10)
                
                VStack(spacing: 10) {
                    let currentCount = CGFloat($currentPhotosCount.wrappedValue)
                    let maxCount = CGFloat(maximumPhotosLimit)
                    if currentPhotosCount <= 40 {
                        ProgressView(value: currentCount, total: maxCount)
                            .accentColor(.primaryRed)
                            .frame(width: UIScreen.screenWidth - 30, height: 6)
                    } else if currentPhotosCount > 40 && currentPhotosCount <= 100 {
                        ProgressView(value: currentCount, total: maxCount)
                            .accentColor(.JungleGreen)
                            .frame(width: UIScreen.screenWidth - 30, height: 6)
                    } else if currentPhotosCount > 100 {
                        ProgressView(value: currentCount, total: maxCount)
                            .accentColor(.theme)
                            .frame(width: UIScreen.screenWidth - 30, height: 6)
                    }
                    
                    HStack {
                        Text("Acceptable")
                            .font(Font.CircularSTDMedium(with: 15))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Optimal")
                            .font(Font.CircularSTDRegular(with: 15))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Ultimate")
                            .font(Font.CircularSTDMedium(with: 15))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                }
                .frame(width: UIScreen.screenWidth, height: 50)
            }
            .padding(.bottom, 50)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: isManualOn) { newValue in
            cameraView.captureModel.isOpenAdvance = newValue
        }
        .onChange(of: evValue) { newValue in
            cameraView.captureModel.evValue = newValue
        }
        .onChange(of: isoValue) { newValue in
            cameraView.captureModel.isoValue = .value(newValue)
        }
        .onChange(of: shutterValue) { newValue in
            cameraView.captureModel.shutterValue = .value(newValue)
        }
        .onAppear {
            setupCameraKit()
        }
    }
    
    private var takePhotoView: some View {
        HStack {
            Spacer()
            
            Button {
                cameraView.takePhoto()
                cameraButtonDisabled = true
                Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { timer in
                    cameraButtonDisabled = false
                    currentPhotosCount = currentPhotosCount + 1
                }
            } label: {
                Image("TakePhoto")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(cameraButtonDisabled ? .gray : .white)
                    .frame(width: 60, height: 60)
            }
            .disabled(cameraButtonDisabled)
            
            Spacer()
        }
    }
    
    private var manualSettingsView: some View {
        VStack {
            Button {
                isExposureSelected = true
                isISOSelected = false
                isShutterSelected = false
            } label: {
                VStack {
                    Text("EV")
                        .font(Font.CircularSTDMedium(with: 15))
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                        .background(isExposureSelected ? Color.white : .gray)
                        .cornerRadius(15)
                    
                    Text("EV: \(Int(evValue))")
                        .font(Font.CircularSTDRegular(with: 15))
                        .foregroundColor(isExposureSelected ? Color.white : .gray)
                }
            }
            
            Button {
                isExposureSelected = false
                isISOSelected = true
                isShutterSelected = false
            } label: {
                VStack {
                    Text("ISO")
                        .font(Font.CircularSTDRegular(with: 15))
                        .foregroundColor(.black)
                        .frame(width: 42, height: 20)
                        .background(isISOSelected ? Color.white : .gray)
                        .cornerRadius(2)
                    
                    Text("ISO: \(Int(isoValue))")
                        .font(Font.CircularSTDRegular(with: 15))
                        .foregroundColor(isISOSelected ? Color.white : .gray)
                }
            }
            
            Button {
                isExposureSelected = false
                isISOSelected = false
                isShutterSelected = true
            } label: {
                VStack {
                    Image("ShutterImage")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isShutterSelected ? Color.white : .gray)
                    
                    Text("SS: 1/\(Int(shutterValue * 100))")
                        .font(Font.CircularSTDRegular(with: 15))
                        .foregroundColor(isShutterSelected ? Color.white : .gray)
                }
            }
            
            if let device = cameraView.captureModel.device {
                if isExposureSelected {
                    Slider(value: $evValue, in: -3...3)
                        .frame(width: 100)
                        .offset(x: -50, y: 0)
                        .rotationEffect(.degrees(-90.0), anchor: .center)
                } else if isISOSelected {
                    Slider(value: $isoValue, in: CGFloat(device.activeFormat.minISO)...CGFloat(device.activeFormat.maxISO))
                        .frame(width: 100)
                        .offset(x: -50, y: 0)
                        .rotationEffect(.degrees(-90.0), anchor: .center)
                } else if isShutterSelected {
                    Slider(value: $shutterValue, in: 0.001...device.activeFormat.maxExposureDuration.time)
                        .frame(width: 100)
                        .offset(x: -50, y: 0)
                        .rotationEffect(.degrees(-90.0), anchor: .center)
                }
            }
        }
    }
    
    private func setupCameraKit() {
        CameraKit.share.setup(envType: .test, account: Constants.KIRI_ACCOUNT, password: Constants.KIRI_PASSWORD) { result in
            switch result {
            case .success:
                self.startPreviewingCamera()
            case .failure:
                print("Error")
            }
        }
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        cameraView.setPhotoFolderPath("\(docPath)/\(Constants.folderName)")
    }
    
    private func startPreviewingCamera() {
        cameraView.startPreview { result in
            print("result:\(result)")
            switch result {
            case .success(let status):
                if status == .authorized {
                    cameraView.captureModel.isOpenAdvance = true
                }
            case .failure:
                break
            }
        }
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
        if let vc: CameraSettingsViewController = UIStoryboard.initiate(storyboard: .camera) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.nftId = nftItem?._id
            UIApplication.topViewController()?.present(vc, animated: true)
        }
    }
}

struct CameraAdvance_Previews: PreviewProvider {
    static var previews: some View {
        CameraAdvance(dismissAction: {})
    }
}

struct CustomToggle: UIViewRepresentable {
    
    @Binding var isOn: Bool
    
    func makeUIView(context: Context) -> YapSwitch {
        let toggle = YapSwitch()
        toggle.offImage = UIImage(named: "MOff")
        toggle.onImage = UIImage(named: "AOff")
        toggle.onTintColor = .theme
        toggle.offTintColor = .theme
        toggle.thumbImage = UIImage(named: "AutoThumb")
        toggle.valueChange = { value in
            if value {
                toggle.thumbImage = UIImage(named: "ManualThumb")
            } else {
                toggle.thumbImage = UIImage(named: "AutoThumb")
            }
            isOn = value
        }
        return toggle
    }
    
    func updateUIView(_ toggle: YapSwitch, context: Context) {
        
    }
}
