//
//  AnyAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
struct AnyAdapter: Adapter {
    let block: (URLRequest) throws -> URLRequest
    
    public
    func apply(_ request: URLRequest) throws -> URLRequest {
        return try block(request)
    }
}
