//
//  WebServiceManager.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation
import UIKit
import SwiftUI

class WebServicesManager {
    
    public static let shared = WebServicesManager()
    
    //MARK:- LOGIN
    func loginUser(with email: String?, password: String?, callBack: RequestCompletionBlock<BaseResponse<User>>.CompletionResponse?) {
        var params = [String: Any]()
        params["email"] = email
        params["password"] = password
        CoreWebService.sendRequest(requestURL: URLs.SERVER_BASE_URL + EndPoint.login.path(), method: .post, paramters: params, showMessageType: .none, callBack: callBack)
    }
    
    func forgotPassword(with email: String?, callBack: RequestCompletionBlock<BaseResponse<EmptyResponse>>.CompletionResponse?) {
        var params = [String: Any]()
        params["email"] = email
        CoreWebService.sendRequest(requestURL: URLs.SERVER_BASE_URL + EndPoint.forgotPassword.path(), method: .post, paramters: params, showMessageType: .none, callBack: callBack)
    }
    
    //MARK:- Home
    func getHomeNFTs(callBack: RequestCompletionBlock<BaseResponse<NFT>>.CompletionResponse?) {
        let params = [String:Any]()
        CoreWebService.sendRequest(requestURL: URLs.SERVER_BASE_URL + EndPoint.homeNFTs.path(), method: .get, paramters: params, showMessageType: .none, callBack: callBack)
    }
    
    // Get token from KIRI
    func getToken(callBack: RequestCompletionBlock<BaseResponse<String>>.CompletionResponse?) {
        var params = [String:Any]()
        params["account"] = Constants.KIRI_ACCOUNT
        params["password"] = Constants.KIRI_PASSWORD
        CoreWebService.sendRequest(requestURL: URLs.KIRI_BASE_URL + EndPoint.getKiriToken.path(), method: .post, paramters: params, showMessageType: .none, callBack: callBack)
    }
    
    func uploadImagesToKiri(images: [UIImage], params: [String: Any], progressCallback: @escaping (Double) -> Void, callBack: RequestCompletionBlock<BaseResponse<String>>.CompletionResponse?) {
        CoreWebService.sendUploadRequest(requestURL: URLs.KIRI_BASE_URL + EndPoint.uploadImages.path(), paramters: params, imagesKey: "files", imagesArr: images, progressCallback: progressCallback, callBack: callBack)
    }
    
    //Upload token to our server
    func updateNFtStatus(nftId: String?, id: String?, selectedFileFormat: String?, media_type: String, callBack: RequestCompletionBlock<BaseResponse<EmptyResponse>>.CompletionResponse?) {
        var params = [String: Any]()
        params["nftId"] = nftId
        params["id"] = id
        params["selectedFileFormat"] = selectedFileFormat
        params["media_type"] = media_type
        CoreWebService.sendRequest(requestURL: URLs.SERVER_BASE_URL + EndPoint.updateStatus.path(), method: .post, paramters: params, showMessageType: .none, callBack: callBack)
    }
    
    func uploadVideoToKiri(video: Data, params: [String: Any], callBack: RequestCompletionBlock<BaseResponse<String>>.CompletionResponse?) {
        CoreWebService.sendUploadRequest(requestURL: URLs.KIRI_BASE_URL + EndPoint.uploadVideo.path(), paramters: params, videoKey: "videoFile", videoData: video, callBack: callBack)
    }
}
