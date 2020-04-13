//
//  Logger.swift
//  Network
//
//  Created by Nick on 4/13/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct Logger: PluginType {
    
    func willSend<Req>(_ request: Req, urlRequest: URLRequest) where Req: Request {
        print("request url: \(urlRequest.url?.absoluteString ?? "EMPTY Request URL")")
        print("request start time: \(Date().timeIntervalSince1970)")
    }
    
    func didReceive<Req>(_ request: Req, result: ResultType) where Req: Request {
        print("request end time: \(Date().timeIntervalSince1970)")
    }
    
}
