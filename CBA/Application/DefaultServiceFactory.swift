//
//  DefaultServiceFactory.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

protocol ServiceFactoryProtocol {
    func makeTransactionService() -> TransactionServiceProtocol
}

struct DefaultServiceFactory: ServiceFactoryProtocol {
    
    let networkConfiguration: NetworkConfiguration
    
    init(networkConfiguration: NetworkConfiguration) {
        self.networkConfiguration = networkConfiguration
    }
    
    func makeTransactionService() -> TransactionServiceProtocol {
        return TransactionService(networkClient: NetworkClient(baseURL: networkConfiguration.baseURL))
    }
}
