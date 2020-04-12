//
//  ContentType.swift
//  Network
//
//  Created by Nick on 4/11/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

enum ContentType {
    case json
    case formURL
    case none
        
    func adapter(for data: [String: Any]) -> Adapter {
        switch self {
        case .json: return JSONRequestAdapter(data: data)
        case .formURL: return FormURLAdapter(data: data)
        case .none: return NoneAdapter()
        }
    }
    
}
