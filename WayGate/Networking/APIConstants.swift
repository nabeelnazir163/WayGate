//
//  APIConstants.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

class URLs {
    static let SERVER_BASE_URL = "https://dev-api.thewaygate.io/"
    static let KIRI_BASE_URL = "http://3.20.175.91:9999/v1/"
}

enum EndPoint: String {
    //Login
    case login = "user/signin"
    
    //NFTS
    case homeNFTs = "nftDraft/list_nft"
    case updateStatus = "nftDraft/nft_status"
    
    //KIRI
    case getKiriToken = "app/auth/open/getToken"
    case uploadImages = "app/calculate/upload"
    
    func path() -> String {
        rawValue
    }
}

