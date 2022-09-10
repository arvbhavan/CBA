//
//  MockTransactionService.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import Foundation

class MockTransactionService: TransactionServiceProtocol {
    enum Event {
        case fetchTransactions
    }
    private(set) var events: [Event] = []

    var resultToReturn: Result<TransactionResponse, TransactionServiceError>?
    func fetchTransactions(completion: @escaping (Result<TransactionResponse, TransactionServiceError>) -> Void) {
        events.append(.fetchTransactions)

        guard let resultToReturn = resultToReturn else {
            fatalError("Should set `resultToReturn` before calling fetchTransactions(..)")
        }
        completion(resultToReturn)
    }
}
