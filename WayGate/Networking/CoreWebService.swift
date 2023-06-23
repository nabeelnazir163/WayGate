//
//  CoreWebService.swift
//  WayGate
//
//  Created by Nabeel Nazir on 01/06/2023.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import Combine

typealias RefreshUICallBack = (_ success:Bool) -> Void
typealias ResponseBlock<T> = (_ sender: T) -> Void
typealias RefreshSectionCallback = (_ section: Int) -> Void
typealias ResponseBlock2<T, E> = (_ sender: T, _ object: E?) -> Void
typealias CompletionBlock = () -> Void
typealias CompletionWithErrorBlock = (_ error: Error?) -> Void

public enum RequestType: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public struct MessageType: OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let none = MessageType(rawValue: 1)
    public static let errorMessage = MessageType(rawValue: 2)
    public static let successMessage = MessageType(rawValue: 4)
}
extension MessageType {
    
    public static let allMessage: MessageType = [.errorMessage, .successMessage]
}


enum AppError: LocalizedError, Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.errorDescription == rhs.localizedDescription
    }
    
    
    case gernalErrorAndCode(code: StatusCode, message: String)
    case gernalError(message: String)
    case ignoreError(message: String)
    case permissionDenied(message: String)
    case genericError(obj: Any)
    
    var errorDescription: String? {
        switch self {
        case .gernalErrorAndCode(code: _, message: let message):
            return message
        case .gernalError(message: let message):
            return message
        case .ignoreError(message: let message):
            return message
        case .permissionDenied(message: let message):
            return message
        case .genericError(obj: let message):
            return (message as? String) ?? ""
        }
    }
    
}

public enum StatusCode: Int, Codable {
    case success = 200
    
    case unVerifiedEmail = 403
    case selectPaymentPlan = 402
    case error = 216
    case invalidCredentials = 205
    case noActiveEmailExists = 206
    case emailSent = 207
    case accountBlocked = 208
    case invalidUserName = 209
    case invalidPassword = 210
    case userNameAlreadyExists = 211
    case userEmailAlreadyExists = 212
    case userEIDAlreadyExists = 213
    case userMobileAlreadyExists = 214
    case userOTPInvalid = 215
    
    var errorMessage: String {
        
        var string = ""
        switch self {
        case .success:
            string = "Success"
        case .error:
            string = "Some thing went wrong"
        case .invalidCredentials:
            string = "Invalid username or password"
        case .noActiveEmailExists:
            string = "No active email exists"
        case .emailSent:
            string = "Email sent"
        case .accountBlocked:
            string = "Account blocked"
        case .invalidUserName:
            string = "Invalid username"
        case .invalidPassword:
            string = "Invalid Password"
        case .userNameAlreadyExists:
            string = "Username already exist"
        case .userEmailAlreadyExists:
            string = "Email already exist"
        case .userEIDAlreadyExists:
            string = "Emirate Id already exist"
        case .userMobileAlreadyExists:
            string = "Mobile No already exist"
        case .userOTPInvalid:
            string = "Invalid OTP"
        default:
            string = ""
        }
        return string
    }
}
public enum RequestCallback<T> {
    case success(T)
    case failed(Error)
}

public struct RequestCompletionBlock<T : Codable> {
    public typealias CompletionResponse = (_ result: RequestCallback<T>) -> Void
}
typealias CompletionResponseData = (_ result: Data?) -> Void

public class CoreWebService: NSObject {
    
    public static let PTS = PassthroughSubject<String, Never>()
    
    static let sharedInstance = CoreWebService()
    public var sessionManager: Alamofire.Session // most of your web service clients will call through sessionManager
    private override init() {
        self.sessionManager = Alamofire.Session(configuration: URLSessionConfiguration.default)
    }
    
    public static func sendRequest<T: Codable>(
        requestURL: String,
        method: RequestType = .post,
        paramters: [String:Any]? = nil,
        queryParams: [String: Any]? = nil,
        mapContext: MapContext? = nil,
        showMessageType: MessageType = .allMessage,
        cacheRequest: Bool = false,
        callBack: RequestCompletionBlock<T>.CompletionResponse?) {
            
            
            
            let completeUrl = requestURL
            
            guard let url = URL(string:completeUrl) else {
                // incorporate error
                return
            }
            var encoding: ParameterEncoding = JSONEncoding.default
            
            if method == .get || method == .delete {
                encoding = URLEncoding.queryString
            }
            
            print("\n\n------------Requested URL-------------\n\n")
            print(url as Any)
            
            print("\n\n------------Request Body-------------\n\n")
            print(paramters as Any)
            let headers = HTTPHeaders(authHeader())
            let requestModel = AF.request(url, method: (HTTPMethod(rawValue: method.rawValue)), parameters: paramters, encoding: encoding, headers: headers)
            
            requestModel.response { response in
                let httpResponse = response.response
                if httpResponse?.statusCode == 401 {
                    DispatchQueue.main.async {
                    }
                    return
                }
                parseResponse(data: response.data, error: response.error, mapContext: mapContext, showMessageType: showMessageType, cacheKey: nil, callBack: callBack)
            }
        }
    
    // Multipart request
    public static func sendUploadRequest<T: Codable>(
        requestURL: String, method: HTTPMethod = .post,
        paramters: [String:Any]? = nil,
        imagesKey: String? = nil,
        imagesArr: [UIImage]? = nil,
        mapContext: MapContext? = nil,
        showMessageType: MessageType = .allMessage,
        cacheRequest: Bool = false,
        progressCallback: @escaping (Double) -> Void,
        callBack: RequestCompletionBlock<T>.CompletionResponse?) {
            let headers = HTTPHeaders(authHeader(isMultipart: true))
            var URL = try! URLRequest(url: requestURL, method: (HTTPMethod(rawValue: method.rawValue)), headers: headers)
            
            print("\n\n------------Requested URL-------------\n\n")
            print(requestURL as Any)
            
            print("\n\n------------Request Body-------------\n\n")
            
            URL.timeoutInterval = TimeInterval(Int.max)
            
            print("IMAGES_COUNT", imagesArr?.count ?? 0)
            
            let requestModel = AF.upload(multipartFormData: { multipartFormData in
                if paramters != nil {
                    for (key, value) in paramters! {
                        if let value = value as? String {
                            if let data = value.data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                }
                
                if imagesArr != nil {
                    for i in 0..<imagesArr!.count {
                        let timestamp = "\(Date().timeIntervalSince1970)"
                        multipartFormData.append(imagesArr![i].jpegData(compressionQuality: 1.0)!, withName: imagesKey!, fileName: "\(timestamp)image.jpg", mimeType: "image/jpeg")
                    }
                }
            }, with: URL)
            requestModel.uploadProgress { progress in
                progressCallback(progress.fractionCompleted)
            }
            requestModel.response { response in
                parseResponse(data: response.data, error: response.error, mapContext: mapContext, showMessageType: showMessageType, cacheKey: nil, callBack: callBack)
            }
        }
    
    private static func parseResponse<T: Codable>(
        data: Data?, error: Error? = nil,
        mapContext: MapContext? = nil,
        showMessageType: MessageType,
        cacheKey: String?,
        callBack: RequestCompletionBlock<T>.CompletionResponse?) {
            
            guard let data = data else {
                return
            }
            
            if let dict = data.toDictionary() {
                
                print("\n\n------------Response Body-------------\n\n")
                print(dict)
                
                var statusCode = 0
                if let status = dict["status"] {
                    statusCode = status as! Int
                }
                if let code = dict["code"] as? Int {
                    statusCode = code
                }
                let message = dict["message"] as? String
                let _: ResponseBlock<AnyObject> = { (_ sender: AnyObject) in
                    
                }
                if statusCode == 200 {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        callBack?(.success(response))
                    } catch {
                        callBack?(.failed(AppError.ignoreError(message: error.localizedDescription)))
                    }
                } else {
                    callBack?(.failed(AppError.gernalError(message: message ?? "")))
                }
            }
            else {
                if let error = error {
                    guard error.localizedDescription.lowercased() != "cancelled".lowercased() else {
                        return
                    }
                    callBack?(.failed(AppError.gernalError(message: "Something went wrong")))
                    return
                }
                if let htmlData = String(data: data, encoding: .ascii)  as? T {
                    callBack?(.success(htmlData))
                } else {
                    callBack?(.failed(AppError.gernalError(message: "Something went wrong")))
                }
            }
        }
    
    private static func parseGoogleResponse<T: Mappable>(
        data: Data?, error: Error? = nil,
        mapContext: MapContext? = nil,
        showMessageType: MessageType,
        cacheKey: String?,
        callBack: RequestCompletionBlock<T>.CompletionResponse?) {
            
            guard let data = data else {
                return
            }
            
            if let dict = data.toDictionary() {
                let cacheBlock: ResponseBlock<AnyObject> = { (_ sender: AnyObject) in
                }
                
                let mapper = Mapper<T>()
                mapper.context = mapContext
                let mapperClass = mapper.map(JSON: dict)!
                cacheBlock(mapperClass as AnyObject)
                callBack?(.success(mapperClass))
            }
            else {
                if let error = error {
                    callBack?(.failed(AppError.gernalError(message: error.localizedDescription)))
                    return
                }
                callBack?(.failed(AppError.gernalError(message: "")))
            }
        }
    
    static func authHeader(isMultipart: Bool = false) -> [String:String] {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        var headers = ["DeviceID":"iOS - \(deviceID)"]
        if let token = UserDefaultsConfig.user?.token {
            headers["Authorization"] = "\(token)"
        }
        headers["Accept"] = "application/json"
        headers["device-type"] = "iOS"
        headers["Connection"] = "Keep-alive"
        if isMultipart {
            headers["Content-type"] = "multipart/form-data"
            headers["token"] = Constants.token
        } else {
            headers["Content-Type"] = "application/json"
        }
        return headers
    }
}

