//
//  MockTransactionResponse.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA

extension TransactionResponse {
    static func makeMock() -> TransactionResponse {
        return TransactionResponse(account: AccountDetail.makeMock(),
                                   transactions: [Transaction.makeMock()],
                                   pending: [Transaction.makeMock()],
                                   atms: [ATMDetail.makeMock()])
    }
}
