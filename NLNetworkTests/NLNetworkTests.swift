//
//  NLNetworkTests.swift
//  NLNetworkTests
//
//  Created by andrew54068 on 4/14/20.
//  Copyright © 2020 kciNniL. All rights reserved.
//

import XCTest
@testable import NLNetwork

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

}
