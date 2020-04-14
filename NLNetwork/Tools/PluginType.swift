//
//  PluginType.swift
//  Network
//
//  Created by Nick on 4/12/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
protocol PluginType {
    typealias ResultType = (Data?, URLResponse?, Error?)
    func willSend<Req: Request>(_ request: Req, urlRequest: URLRequest)
    func didReceive<Req: Request>(_ request: Req, result: ResultType)
}
