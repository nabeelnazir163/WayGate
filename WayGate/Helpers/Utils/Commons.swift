//
//  Commons.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import UIKit
import Lottie

let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first

class Commons {
    
    static let ActivityViewTag = 121
    static let LoaderBGView = 122
    
    static func showAlert(title: String = "WayGate", msg: String)  {
        window?.endEditing(true)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        if let vc = UIApplication.topViewController() {
            vc.present(alert, animated: true, completion: nil)
        } else if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func goToWelcomeView() {
        if let vc: IntroSliderViewController = UIStoryboard.initiate(storyboard: .splash) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    static func goToMain() {
        if let vc: TabbarViewController = UIStoryboard.initiate(storyboard: .main) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    static func goToLogin() {
        UserDefaultsConfig.user = nil
        
        if let vc: LoginViewController = UIStoryboard.initiate(storyboard: .auth) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    public class func showActivityIndicator() -> Void {

        let animationView: LottieAnimationView = .init(name: "Loader")
        animationView.tag = ActivityViewTag
        animationView.backgroundColor = .white
        animationView.cornerRadius = 12

        if let window = UIApplication.shared.windows.first {

            let BGView = UIView()
            BGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            BGView.tag = LoaderBGView
            BGView.frame = window.frame

            if let bgView = window.viewWithTag(LoaderBGView) {
                bgView.removeFromSuperview()
            }

            if let activityView = window.viewWithTag(ActivityViewTag)
            {
                activityView.removeFromSuperview()
            }

            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1

            window.addSubview(BGView)

            window.addSubview(animationView)

            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            animationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            animationView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            animationView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true

            // 6. Play animation
            animationView.play()
        }
    }

    public class func hideActivityIndicator() -> Void {

        if let window = UIApplication.shared.windows.first {

            if let activityView = window.viewWithTag(ActivityViewTag)
            {
                // activityView.hideLoading()
                activityView.removeFromSuperview()
            }

            if let bgView = window.viewWithTag(LoaderBGView) {
                bgView.removeFromSuperview()
            }
        }
    }
    
    static func loadImagesFromAlbum(folderName: String) -> [String]{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        var theItems = [String]()
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(folderName)
            do {
                theItems = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
                return theItems
            } catch let error as NSError {
                print(error.localizedDescription)
                return theItems
            }
        }
        return theItems
    }
    
    static func deleteDirectory(name: String) {
        let fileManager = FileManager.default
        let yourProjectImagesPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: yourProjectImagesPath) {
            try! fileManager.removeItem(atPath: yourProjectImagesPath)
        }
        let yourProjectDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: yourProjectDirectoryPath) {
            try! fileManager.removeItem(atPath: yourProjectDirectoryPath)
        }
    }
    
    static func getImagesFromDirectory() -> [UIImage] {
        var imagesToUpload = [UIImage]()
        let imageURLs = Commons.loadImagesFromAlbum(folderName: Constants.folderName)
        for url in imageURLs {
            var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            path = path + "/\(Constants.folderName)/" + url
            if let image = UIImage(contentsOfFile: path) {
                imagesToUpload.append(image)
            }
        }
        return imagesToUpload
    }
}
