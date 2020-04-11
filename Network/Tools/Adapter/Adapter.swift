//
//  Adapter.swift
//  Network
//
//  Created by Nick on 4/10/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

protocol Adapter {
    func adapted(_ request: URLRequest) throws -> URLRequest
}
