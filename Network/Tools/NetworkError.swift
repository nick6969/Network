//
//  NetworkError.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

enum QueryError: Error {
    case urlNotCorrect
    case queryItemError
}

enum ResponseError: Error {
    case nilData
    case nonHTTPResponse
    case apiError(statusCode: Int, body: Data)
}
