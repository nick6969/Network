//
//  Request.swift
//  Network
//
//  Created by Nick on 4/10/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
protocol Request {
    
    associatedtype Response: Decodable

    var url: URL { get }
    var method: Method { get }
    var contentType: ContentType { get }
    var content: [String: Any] { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    
    var adapters: [Adapter] { get }
    var decisions: [Decision] { get }
}

extension Request {
    
    // setup default value
    var method: Method { .get }
    var contentType: ContentType { .json }
    var content: [String: Any] { [:] }
    var headers: [String: String]? { nil }
    var query: [String: String]? { nil }

    // this is build the request use
    var defaultAdapter: [Adapter] {
        return [
            QueryAdapter(url: url, data: query),
            HeaderAdapter(data: headers),
            ContentAdapter(method: method, contentType: contentType, content: content)
        ]
    }
    
    // this is default decisions, retry and check status and convert data to model
    var defaultDecisions: [Decision] {
        return [
            RetryDecision(retryCount: 2),
            StatusCodeDecision(),
            DecodeJSONResultDecision()
        ]
    }
    
    // if customer adapters, remeber use defaultAdapter
    var adapters: [Adapter] { defaultAdapter }
    
    // using defaultDecisions to convert data to response model, can custome by your self
    var decisions: [Decision] { defaultDecisions }

    // this method will build the url request
    func buildRequest() throws -> URLRequest {
        let request = URLRequest(url: url)
        return try adapters.reduce(request) { try $1.apply($0) }
    }
    
}
