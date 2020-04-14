//
//  Session.swift
//  Network
//
//  Created by Nick on 4/12/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

public
protocol Session {

    var delegate: URLSessionDelegate? { get }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

extension URLSession: Session {}
