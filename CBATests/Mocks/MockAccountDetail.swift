//
//  MockAccountDetail.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA

extension AccountDetail {
    static func makeMock() -> AccountDetail {
        AccountDetail(accountName: "Complete Access", accountNumber: "123456 7895 45623", available: 100, balance: 120)
    }
}
