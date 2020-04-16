//
//  NLNetworkTests.swift
//  NLNetworkTests
//
//  Created by andrew54068 on 4/14/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import XCTest
@testable import NLNetwork

struct AppleStoreAppInfo {
    let identifier: String
    let country: String
}

extension AppleStoreAppInfo: Request {

    var url: URL { URL(string: "http://itunes.apple.com/lookup")! }
    var query: [String: String]? {
        ["id": identifier,
         "country": country,
         "time": "\(Date().timeIntervalSince1970)"]
    }

    typealias Response = AppleStoreAppInfoModel
}

struct AppleStoreAppInfoModel: Decodable {
    let resultCount: Int
    let results: [AppleStoreAppInfoResultModel]
}

struct AppleStoreAppInfoResultModel: Decodable {
    let version: String
    let trackCensoredName: String
    let description: String
    let languageCodesISO2A: [String]
}

struct EmptyModel: Decodable, Comparable {
    static func < (lhs: EmptyModel, rhs: EmptyModel) -> Bool {
        return true
    }
}

struct EmptyResponseRequest: Request {

    typealias Response = EmptyModel

    var url: URL { URL(string: "http://empty.com")! }

}

class NLNetworkTests: XCTestCase {

    let expectation = XCTestExpectation(description: "should not hit any assert.")
    let requestInfo: AppleStoreAppInfo = AppleStoreAppInfo(identifier: "", country: "")

    func testAppleStoreApi() {

        let url: URL = requestInfo.url
        let data: Data = DataResource.getDataFromBundleFile(name: "mockResult", type: "json")
        let response: HTTPURLResponse = .init(url: url,
                                              mimeType: nil,
                                              expectedContentLength: 1024,
                                              textEncodingName: nil)
        
        let mockSession = MockSession(data: data,
                                      response: response,
                                      error: nil,
                                      waiting: 0.3)
        HTTPClient(session: mockSession).send(requestInfo) { result in
            switch result {
            case .success(let appleStoreAppInfoModel):
                XCTAssert(appleStoreAppInfoModel.resultCount == 2, "resultCount should equal 2")
                XCTAssert(appleStoreAppInfoModel.results[0].description == "this is description", "description should equal \"this is description\"")
                XCTAssert(appleStoreAppInfoModel.results[0].trackCensoredName == "test trackCensoredName", "trackCensoredName should equal \"test trackCensoredName\"")
                XCTAssert(appleStoreAppInfoModel.results[0].version == "0.0.1", "version should equal \"0.0.1\"")
                XCTAssert(appleStoreAppInfoModel.results[0].languageCodesISO2A[0] == "A", "languageCodesISO2A[0] should equal \"A\"")
                XCTAssert(appleStoreAppInfoModel.results[0].languageCodesISO2A[1] == "B", "languageCodesISO2A[0] should equal \"B\"")

                XCTAssert(appleStoreAppInfoModel.results[1].description == "this is description2", "description should equal \"this is description2\"")
                XCTAssert(appleStoreAppInfoModel.results[1].trackCensoredName == "test trackCensoredName2", "trackCensoredName should equal \"test trackCensoredName2\"")
                XCTAssert(appleStoreAppInfoModel.results[1].version == "0.0.2", "version should equal \"0.0.2\"")
                XCTAssert(appleStoreAppInfoModel.results[1].languageCodesISO2A[0] == "C", "languageCodesISO2A[0] should equal \"C\"")
                XCTAssert(appleStoreAppInfoModel.results[1].languageCodesISO2A[1] == "D", "languageCodesISO2A[0] should equal \"D\"")
                self.expectation.fulfill()

            case .failure(let error):
                XCTFail("should not be failure error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 0.4)
    }

    func testEmptyModel() {
        let request: EmptyResponseRequest = EmptyResponseRequest()
        let url: URL = request.url
        let response: HTTPURLResponse = .init(url: url,
                                              mimeType: nil,
                                              expectedContentLength: 1024,
                                              textEncodingName: nil)

        let mockSession = MockSession(data: "{}".data(using: .utf8)!,
                                      response: response,
                                      error: nil,
                                      waiting: 0.3)
        let expectModel: EmptyModel = EmptyModel()
        HTTPClient(session: mockSession).send(request) { result in
            switch result {
            case .success(let emptyModel):
                XCTAssert(emptyModel == expectModel, "model should be EmptyModel")
                self.expectation.fulfill()

            case .failure(let error):
                XCTFail("should not be failure error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 0.4)
    }

    func testJsonAdapter() throws {
        let request: URLRequest = .init(url: requestInfo.url)
        let testData: [String: String] = ["testKey": "test"]
        let jsonAdapter: JSONRequestAdapter = JSONRequestAdapter(data: testData)
        let resultRequest: URLRequest = try jsonAdapter.apply(request)

        let expectHeader: String = "application/json"
        assert(resultRequest.allHTTPHeaderFields?["Content-Type"] == expectHeader, "request header should be \(expectHeader) but found \(String(describing: resultRequest.allHTTPHeaderFields?["Content-Type"])).")

        let expectedBody: Data = try JSONSerialization.data(withJSONObject: testData, options: [])
        assert(resultRequest.httpBody == expectedBody, "httpBody should be \(expectedBody)")
    }

    func testAnyAdapter() throws {

        struct AnyAdapter: Adapter {
            let block: (URLRequest) throws -> URLRequest

            public
            func apply(_ request: URLRequest) throws -> URLRequest {
                return try block(request)
            }
        }

        let request: URLRequest = .init(url: requestInfo.url)
        let adapter: AnyAdapter = AnyAdapter { request -> URLRequest in
            var request = request
            request.httpMethod = Method.post.rawValue
            return request
        }
        let resultRequest: URLRequest = try adapter.apply(request)

        assert(resultRequest.httpMethod == Method.post.rawValue, "request method should be \(Method.post.rawValue) but found \(String(describing: resultRequest.httpMethod)).")
    }

}
