//
//  MethodAdapter.swift
//  NLNetworkTests
//
//  Created by Nick on 4/16/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
struct MethodAdapter: Adapter {
    let method: Method
    
    public
    func apply(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpMethod = self.method.rawValue
        return request
    }
    
}
