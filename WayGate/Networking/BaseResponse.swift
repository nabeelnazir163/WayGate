//
//  BaseResponse.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

class BaseResponse<T: Codable>: Codable {
    var status: Int?
    var message: String?
    
    var dataObject: T?
    var token: String?
        
    enum CodingKeys : String, CodingKey {
        case status, message, dataObject = "data"
    }
}

struct EmptyResponse: Codable{
    var status: Int?
    var message: String?
    var success: Bool?
}
