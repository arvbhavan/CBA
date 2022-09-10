//
//  TransactionListScreen.swift
//  CBAUITests
//
//  Created by Aravind R on 19/09/21.
//

import XCTest

final class TransactionListScreen: CBAUIElement {
    
    private enum Identifiers {
        // Account Detail Cell
        static let accountDetail = "AccountDetailTableViewCell"
        static let transaction = "TransactionTableViewCell-section-%ld-row-%ld"
    }
    
    func getAccountDetail() throws -> AccountDetail {
        let accountDetailCell = element.cells[Identifiers.accountDetail]
        guard accountDetailCell.waitForExistence(timeout:  Timeout.small.rawValue) else {
            throw CBAAppError.elementDoesNotExist("Account detail cell not found")
        }
        
        return AccountDetail(app: app, element: accountDetailCell)
    }

    func getTransaction(at section: Int, row: Int) throws -> Transaction {
        let identifier = String(format: Identifiers.transaction, section, row)
        let transactionCell = element.cells[identifier]
        guard transactionCell.waitForExistence(timeout:  Timeout.small.rawValue) else {
            throw CBAAppError.elementDoesNotExist("Transaction cell not found at section -\(section), row -\(row)")
        }
        
        return Transaction(app: app, element: transactionCell)
    }
}

final class AccountDetail: CBAUIElement {
    private enum Identifiers {
        static let accountName = "AccountDetailTableViewCell.accountNameLabel"
        static let accountNumber = "AccountDetailTableViewCell.accountNumberLabel"
        static let availableFundsTitle = "AccountDetailTableViewCell.availableFundsTitleLabel"
        static let availableFundsValue = "AccountDetailTableViewCell.availableFundsValueLabel"
        static let accountBalanceTitle = "AccountDetailTableViewCell.accountBalanceTitleLabel"
        static let accountBalanceValue = "AccountDetailTableViewCell.accountBalanceValueLabel"
    }
    
    func verifyAccountDetail() throws {
        let fundsTitle = element.staticTexts[Identifiers.availableFundsTitle].firstMatch
        XCTAssertTrue(fundsTitle.exists, "Funds title label not found - \(AccountDetail.self)")
        
        let fundsValue = element.staticTexts[Identifiers.availableFundsValue].firstMatch
        XCTAssertTrue(fundsValue.exists, "Funds value label not found - \(AccountDetail.self)")

        let accountBalanceTitle = element.staticTexts[Identifiers.accountBalanceTitle].firstMatch
        XCTAssertTrue(accountBalanceTitle.exists, "Account Balance title label not found - \(AccountDetail.self)")
        
        let accountBalanceValue = element.staticTexts[Identifiers.accountBalanceValue].firstMatch
        XCTAssertTrue(accountBalanceValue.exists, "Account Balance value label not found - \(AccountDetail.self)")
    }
}

final class Transaction: CBAUIElement {
    private enum Identifiers {
        static let atmImage = "TransactionTableViewCell.atmImageView"
        static let description = "TransactionTableViewCell.detailLabel"
        static let amount = "TransactionTableViewCell.amountLabel"
        static let atmDetailScreen = "ATMMapViewController.mapView"
    }
    
    func verifyTransaction(hasLocation: Bool, pending: Bool) throws {
        let atmImage = element.images[Identifiers.atmImage]
        XCTAssertEqual(atmImage.exists, hasLocation, "ATM Image \(hasLocation ? "is" : "is not") expected - \(Transaction.self)")
        
        let description = element.staticTexts[Identifiers.description]
        XCTAssertTrue(description.exists, "Description not found - \(Transaction.self)")
        
        let amount = element.staticTexts[Identifiers.amount]
        XCTAssertTrue(amount.exists, "Amount not found - \(Transaction.self)")
    }
    
    @discardableResult
    func getATMDetail() throws -> ATMDetailScreen? {
        let atmImage = element.images[Identifiers.atmImage]
        let canShowATMDetail = atmImage.exists
        
        element.tap()
        let atmDetail = app.otherElements[Identifiers.atmDetailScreen].firstMatch

        guard canShowATMDetail else {
            XCTAssertFalse(atmDetail.exists, "ATM Detail screen should not be presented")
            return nil
        }
        
        guard atmDetail.waitForExistence(timeout:  Timeout.small.rawValue) else {
            throw CBAAppError.elementDoesNotExist("ATM Detail not found - \(Transaction.self)")
        }
        return ATMDetailScreen(app: app, element: atmDetail)
    }
}
