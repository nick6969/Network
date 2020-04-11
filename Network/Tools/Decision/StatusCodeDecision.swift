//
//  StatusCodeDecision.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct StatusCodeDecision: Decision {

    func shouldApply<Req>(request: Req, data: Data, response: HTTPURLResponse) -> Bool where Req: Request {
        return !(200..<300).contains(response.statusCode)
    }
    
    func apply<Req>(request: Req, data: Data, response: HTTPURLResponse, done closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        closure(.errored(ResponseError.apiError(statusCode: response.statusCode, body: data)))
    }

}
