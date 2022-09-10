//
//  MockTransaction.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import Foundation

extension Transaction {
    static func makeMock() -> Transaction {
        Transaction(id: "43243255",
                    effectiveDate: Date(),
                    description: "Woolworths shopping",
                    amount: 40,
                    atmId: nil)
    }
}
