//
//  JSONRequestAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct JSONRequestAdapter: Adapter {
    let data: [String: Any]
    
    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        return request
    }
}
