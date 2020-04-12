//
//  HeaderAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct HeaderAdapter: Adapter {
    let data: [String: String]?
    
    func apply(_ request: URLRequest) throws -> URLRequest {
        guard let data = data else { return request }
        var request = request
        for (key, value) in data {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
