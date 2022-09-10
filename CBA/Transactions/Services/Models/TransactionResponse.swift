//
//  TransactionResponse.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct TransactionResponse: Decodable {
    let account: AccountDetail
    let transactions: [Transaction]
    let pending: [Transaction]
    let atms: [ATMDetail]
}

struct Transaction: Decodable {
    let id: String
    let effectiveDate: Date
    let description: String
    let amount: Decimal
    let atmId: String?
}

struct AccountDetail: Decodable {
    let accountName: String
    let accountNumber: String
    let available: Decimal
    let balance: Decimal
}

struct ATMDetail: Decodable {
    let id: String
    let name: String
    let address: String
    let location: Location
}

struct Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    let latitude: Double
    let longitude: Double
}
