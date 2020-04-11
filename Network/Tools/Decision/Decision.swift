//
//  Decision.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

enum DecisionAction<Req: Request> {
    case next(Data, HTTPURLResponse)
    case restart([Decision])
    case errored(Error)
    case done(Req.Response)
}

protocol Decision {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool
    func apply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse, done closure: @escaping (DecisionAction<Req>) -> Void)
}
