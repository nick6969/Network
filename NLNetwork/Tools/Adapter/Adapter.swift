//
//  Adapter.swift
//  Network
//
//  Created by Nick on 4/10/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
protocol Adapter {
    func apply(_ request: URLRequest) throws -> URLRequest
}
