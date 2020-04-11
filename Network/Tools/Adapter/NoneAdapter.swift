//
//  NoneAdapter.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct NoneAdapter: Adapter {
    func adapted(_ request: URLRequest) throws -> URLRequest {
        return request
    }
}
