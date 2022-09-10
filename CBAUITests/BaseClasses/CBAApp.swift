//
//  CBAApp.swift
//  CBAUITests
//
//  Created by Aravind R on 19/09/21.
//

import XCTest

enum Timeout: TimeInterval {
    case small = 10
    case medium = 20
    case large = 30
}

open class CBAApp: XCUIApplication {
    private enum Identifier {
        static let tableView = "TransactionListViewController.tableView"
    }

    func getTransactionListScreen() throws -> TransactionListScreen {
        let element = tables[Identifier.tableView]
        guard element.waitForExistence(timeout: Timeout.large.rawValue) == true else {
            throw CBAAppError.elementDoesNotExist("Transaction list table not found")
        }

        return TransactionListScreen(app: self, element: element)
    }
}
