//
//  HttpClient.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
struct HTTPClient {

    private let session: Session
    
    init(session: Session) {
        self.session = session
    }

    public
    func send<Req: Request>(_ request: Req,
                            plugins: [PluginType] = [],
                            handler: @escaping (Result<Req.Response, Error>) -> Void) {
        self.send(request, decisions: request.decisions, plugins: plugins, handler: handler)
    }
    
    private
    func send<Req: Request>(_ request: Req,
                            decisions: [Decision] = [],
                            plugins: [PluginType] = [],
                            handler: @escaping (Result<Req.Response, Error>) -> Void) {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.buildRequest()
        } catch {
            handler(.failure(error))
            return
        }
        
        if urlRequest.httpMethod == nil {
            handler(.failure(QueryError.methodNotSetup))
            return
        }
        
        plugins.forEach { $0.willSend(request, urlRequest: urlRequest) }
        
        session.dataTask(with: urlRequest) { data, response, error in
        
            plugins.forEach { $0.didReceive(request, result: (data, response, error)) }
            
            guard let data = data else {
                handler(.failure(error ?? ResponseError.nilData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(ResponseError.nonHTTPResponse))
                return
            }
            
            self.handleDecision(request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
        }.resume()
    }
    
    private
    func handleDecision<Req: Request>(_ request: Req,
                                      data: Data,
                                      response: HTTPURLResponse,
                                      decisions: [Decision],
                                      plugins: [PluginType],
                                      handler: @escaping (Result<Req.Response, Error>) -> Void) {
        
        if decisions.isEmpty {
            handler(.failure(FlowError.decisionsEmpty))
            return
        }
        
        var decisions = decisions
        let currentDecision = decisions.removeFirst()
        
        if !currentDecision.shouldApply(request: request, data: data, response: response) {
            handleDecision(request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            return
        }

        currentDecision.apply(request: request, data: data, response: response) { action in
            switch action {
            case .next(let data, let response):
                self.handleDecision(request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            case .restart(let decisions):
                self.send(request, decisions: decisions, plugins: plugins, handler: handler)
            case .errored(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            case .done(let value):
                DispatchQueue.main.async {
                    handler(.success(value))
                }
            }
        }
    }

}
