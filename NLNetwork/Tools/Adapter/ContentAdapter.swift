//
//  ContentAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
struct ContentAdapter: Adapter {
    let method: Method
    let contentType: ContentType
    let content: [String: Any]

    public
    func apply(_ request: URLRequest) throws -> URLRequest {
        switch method {
        case .get: return request
        case .post:
            return try contentType.adapter(for: content).apply(request)
        }
    }
}
