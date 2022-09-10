//
//  MockATMDetail.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA

extension ATMDetail {
    static func makeMock() -> ATMDetail {
        ATMDetail(id: "ATM123",
                  name: "Darling Harbour ATM",
                  address: "77 kent street, NSW, 2000",
                  location: Location.makeMock())
    }
}
