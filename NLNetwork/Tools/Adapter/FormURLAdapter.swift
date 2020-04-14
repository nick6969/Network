//
//  FormURLAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
struct FormURLAdapter: Adapter {
    let data: [String: Any]
    
    public
    func apply(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody =
            data.map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .data(using: .utf8)
        return request
    }
}
