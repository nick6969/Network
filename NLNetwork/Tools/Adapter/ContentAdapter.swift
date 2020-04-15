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
        // why head / get / delete not apply content to HttpBody
        // https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.4
        // https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.1.2
        // https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-odata/7c419053-0f81-450f-aafa-c92ff4b43b7f?redirectedfrom=MSDN
        
        case .head, .get, .delete:
            return request
            
        case .post, .put:
            return try contentType.adapter(for: content).apply(request)
        }
    }
}
