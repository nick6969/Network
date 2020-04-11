//
//  RetryDecision.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

struct RetryDecision: Decision {
    let retryCount: Int
    
    func shouldApply<Req>(request: Req, data: Data, response: HTTPURLResponse) -> Bool where Req: Request {
        let isStatusCodeValid = (200..<300).contains(response.statusCode)
        return !isStatusCodeValid && retryCount > 0
    }

    func apply<Req>(request: Req, data: Data, response: HTTPURLResponse, done closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        let retryDecision = RetryDecision(retryCount: retryCount - 1)
        var newDecisions = request.decisions
        newDecisions.removeFirst()
        newDecisions.insert(retryDecision, at: 0)
        closure(.restart(newDecisions))
    }
    
}
