//
//  ViewController.swift
//  Network
//
//  Created by Nick on 4/10/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sendRequest()
    }

    private
    func sendRequest() {
        let req = AppleStoreAppInfo(identifier: "1069511488", country: "tw")
        let plugins = [Logger()]
        HTTPClient(session: URLSession.shared).send(req, plugins: plugins) { result in
            switch result {
            case .success(let model):
                print(model.results.first?.trackCensoredName ?? "EMPTY title")
            case .failure(let error):
                print(error)
            }
        }
    }
}
