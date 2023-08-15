//
//  APIConstants.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

class URLs {
    static let SERVER_BASE_URL = "https://dev-api.thewaygate.io/"
//    static let KIRI_BASE_URL = "https://partner.kiri-engine.com/v2/"
    static let KIRI_BASE_URL = "https://test.partner.kiri-engine.com/v1/"
}

enum EndPoint: String {
    //Login
    case login = "user/signin"
    case forgotPassword = "user/forget_password"
    
    //NFTS
    case homeNFTs = "nftDraft/list_nft"
    case updateStatus = "nftDraft/nft_status"
    
    //KIRI
    case getKiriToken = "app/auth/open/getToken"
    case uploadImages = "app/calculate/upload"
    case uploadVideo = "app/calculateNerf/upload"
    
    func path() -> String {
        rawValue
    }
}

