//
//  AppleStoreAppInfo.swift
//  Network
//
//  Created by Nick on 4/13/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct AppleStoreAppInfo {
    let identifier: String
    let country: String
}

extension AppleStoreAppInfo: Request {
    
    var url: URL { URL(string: "http://itunes.apple.com/lookup")! }
    var query: [String: String]? {
        ["id": identifier,
         "country": country,
         "time": "\(Date().timeIntervalSince1970)"]
    }
    
    typealias Response = AppleStoreAppInfoModel
}

struct AppleStoreAppInfoModel: Decodable {
    let resultCount: Int
    let results: [AppleStoreAppInfoResultModel]
}

struct AppleStoreAppInfoResultModel: Decodable {
    let version: String
    let trackCensoredName: String
    let description: String
    let languageCodesISO2A: [String]
}
