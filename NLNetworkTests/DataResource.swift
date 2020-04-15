//
//  DataResource.swift
//  NetworkTests
//
//  Created by kidnapper on 2020/4/14.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import Foundation

enum FileError: Error {
    case testBundleNotExist
    case sourceNotFound
    case dataFormateError
}

enum DataResource {

    static func getDataFromBundleFile(name: String, type: String) -> Data {
        do {
            return try readFile(name: name, type: type)
        } catch {
            assertionFailure("error: \(error)")
            return Data()
        }
    }

    private static func readFile(name: String, type: String) throws -> Data {
        guard let testBundle: Bundle = Bundle.allBundles.filter({ $0.bundlePath.contains("NLNetworkTests.xctest") }).first else {
            throw FileError.testBundleNotExist
        }
        guard let sourceUrl: URL = testBundle.url(forResource: name,
                                                  withExtension: type) else {
                                                    throw FileError.sourceNotFound
        }
        guard let jsonData: Data = try? Data(contentsOf: sourceUrl,
                                             options: .dataReadingMapped) else {
                                                throw FileError.dataFormateError
        }
        return jsonData
    }

}
