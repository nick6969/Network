//
//  Network.swift
//  Network
//
//  Created by Nick on 4/10/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
    
    var adapter: AnyAdapter {
        return AnyAdapter { request in
            var request = request
            request.httpMethod = self.rawValue
            return request
        }
    }
}
