//
//  SessionMock.swift
//  Network
//
//  Created by Nick on 4/12/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

@testable import NLNetwork
import Foundation

final class MockSession {
    
    private let mockDataTask: MockSessionDataTask
    
    init(data: Data?, response: URLResponse?, error: Error?, waiting time: TimeInterval) {
        mockDataTask = MockSessionDataTask()
        mockDataTask.taskResponse = (data, response, error)
        mockDataTask.waitingTime = time
    }
    
}

extension MockSession: Session {
    
    var delegate: URLSessionDelegate? { nil }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockDataTask.completionHander = completionHandler
        return mockDataTask
    }
    
}

private class MockSessionDataTask: URLSessionDataTask {
    
    fileprivate typealias Response = (Data?, URLResponse?, Error?)
    fileprivate var taskResponse: Response?
    fileprivate var waitingTime: TimeInterval = 0.0
    fileprivate var completionHander: ((Data?, URLResponse?, Error?) -> Void)?
    
    override func resume() {
        DispatchQueue.global().asyncAfter(deadline: .now() + waitingTime) {
            self.completionHander?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
        }
    }
    
}
