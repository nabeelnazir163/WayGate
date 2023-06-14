//
//  NFT.swift
//  WayGate
//
//  Created by Nabeel Nazir on 06/06/2023.
//

import Foundation

struct NFT: Codable {
    var nfts: [NFTItem]?
}

struct NFTItem: Codable {
    var _id: String?
    var title: String?
    var description: String?
    var status: NFTStatus?
    var threeDfile: [ThreeDFile]?
    var createdAt: String?
}

struct ThreeDFile: Codable {
    var fileName: String?
    var s3Url: String?
    var _id: String?
}

enum NFTStatus: String, Codable {
    case DRAFT, PROCESSED, INPROCESSING, FAILED, COMPLETED
}
