//
//  TransactionRequestConfigurationTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionRequestConfigurationTests: XCTestCase {

    func testRequestConfigurationHTTPMethod() {
        let requestConfiguration = TransactionRequestConfiguration()
        XCTAssertEqual(requestConfiguration.httpMethod, .get)
    }

    func testRequestConfigurationRequestPath() {
        let requestConfiguration = TransactionRequestConfiguration()
        XCTAssertEqual(requestConfiguration.requestPath, "/s/tewg9b71x0wrou9/data.json?dl=1")
    }
}
