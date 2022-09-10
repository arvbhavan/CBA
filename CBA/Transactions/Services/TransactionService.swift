//
//  TransactionsService.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

enum TransactionServiceError: Error {
    case noInternetConnection
    case serviceUnavailable

//    init(_ error: Error) {
//        // TODO: Network error transformation
//    }
}

protocol TransactionServiceProtocol {
    func fetchTransactions(completion: @escaping (Result<TransactionResponse, TransactionServiceError>) -> Void)
}

final class TransactionService: TransactionServiceProtocol {
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchTransactions(completion: @escaping (Result<TransactionResponse, TransactionServiceError>) -> Void) {
        let request = TransactionRequestConfiguration()
        networkClient.performRequest(request, responseConfigurationType: TransactionResponseConfiguration.self) { result in
            switch result {
            case .success(let transactionResponse):
                completion(.success(transactionResponse))
            case .failure(_):
                // TODO: Network error transformation
                break
            }
        }
    }
}
