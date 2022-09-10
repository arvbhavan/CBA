//
//  AccountDetailCellViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct AccountDetailCellViewModel {

    private enum Strings {
        static let availableFunds = "available.funds.title"
        static let accountBalance = "account.balance.title"
    }
    
    private let accountDetail: AccountDetail

    init(accountDetail: AccountDetail) {
        self.accountDetail = accountDetail
    }

    var accountName: String {
        accountDetail.accountName
    }

    var accountNumber: String {
        accountDetail.accountNumber
    }

    let availableFundsTitle = Strings.availableFunds.localized
    var availableFundsText: String? {
        let decimalNumber = NSDecimalNumber(decimal: accountDetail.available)
        return NumberFormatter.currency.string(from: decimalNumber)
    }

    let accountBalanceTitle: String = Strings.accountBalance.localized
    var accountBalanceText: String? {
        let decimalNumber = NSDecimalNumber(decimal: accountDetail.balance)
        return NumberFormatter.currency.string(from: decimalNumber)
    }

    var cellAccessibilityText: String {
        return [accountName, accountNumber,
                availableFundsTitle, availableFundsText,
                accountBalanceTitle, accountBalanceText]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
