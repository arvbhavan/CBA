//
//  TransactionServiceTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionServiceTests: XCTestCase {

    private var mockNetworkClient: MockNetworkClient<TransactionResponse>!
    private var service: TransactionService!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockNetworkClient = MockNetworkClient()
        service = TransactionService(networkClient: mockNetworkClient)
    }

    override func tearDownWithError() throws {
        mockNetworkClient = nil
        service = nil

        try super.tearDownWithError()
    }

    func testFetchTransactionsForSuccess() {
        // Given
        let responseData = TransactionResponse.makeMock()
        mockNetworkClient.responseToReturn = responseData
        
        // When
        var resultReturned: Result<TransactionResponse, TransactionServiceError>?
        service.fetchTransactions { result in
            resultReturned = result
        }
        
        // Then
        XCTAssertEqual(mockNetworkClient.requestConfigurationReceived?.httpMethod, .get)
        XCTAssertEqual(mockNetworkClient.requestConfigurationReceived?.requestPath, "/s/tewg9b71x0wrou9/data.json?dl=1")
        XCTAssertTrue(mockNetworkClient.responseConfigurationTypeReceived is TransactionResponseConfiguration.Type)

        switch resultReturned {
        case .success(let response):
            XCTAssertNotNil(response)
        default:
            XCTFail("Expected a valid transaction response")
        }
    }
}
