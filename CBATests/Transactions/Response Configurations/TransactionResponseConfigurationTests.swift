//
//  TransactionResponseConfigurationTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionResponseConfigurationTests: XCTestCase {

    func testResponseConfigurationResponseModelType() {
        XCTAssertTrue(TransactionResponseConfiguration.ResponseModel.self == TransactionResponse.self)
    }

    func testResponseConfigurationDateDecodingStrategy() {
        let dateDecodingStrategy = TransactionResponseConfiguration.dateDecodingStrategy
        switch dateDecodingStrategy {
        case .formatted(let formatter):
            XCTAssertEqual(formatter.dateFormat, "dd/MM/yyyy")
        default:
            XCTFail("Invalid date decoding strategy")
        }
    }
}
