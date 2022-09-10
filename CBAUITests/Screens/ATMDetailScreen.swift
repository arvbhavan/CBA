//
//  ATMDetailScreen.swift
//  CBAUITests
//
//  Created by Aravind R on 19/09/21.
//

import XCTest

final class ATMDetailScreen: CBAUIElement {
    private enum Identifiers {
        static let backButton = "Back"
        static let annotation = "ATMMapViewController.annotationView"
        static let tableView = "TransactionListViewController.tableView"
    }

    func tapAnnotation() throws -> LocationDetail {
        let annotation = element.otherElements[Identifiers.annotation]
        
        guard annotation.waitForExistence(timeout: Timeout.medium.rawValue) else {
            throw CBAAppError.elementDoesNotExist("ATM location annotation not found")
        }
        
        annotation.tap()
        
        return LocationDetail(app: app, element: annotation)
    }

    @discardableResult
    func navigateBack() throws -> TransactionListScreen {
        let back = app.buttons[Identifiers.backButton]
        
        guard back.waitForExistence(timeout:  Timeout.small.rawValue) else {
            throw CBAAppError.elementDoesNotExist("ATM location annotation not found")
        }
        back.tap()
        
        let element = app.tables[Identifiers.tableView]
        guard element.waitForExistence(timeout:  Timeout.small.rawValue) == true else {
            throw CBAAppError.elementDoesNotExist("Transaction list table not found")
        }

        return TransactionListScreen(app: app, element: element)
    }
}

final class LocationDetail: CBAUIElement {
    func verifyLocationDetail(text: String) {
        XCTAssertEqual(element.label, text, "ATM Location detail (address) is not matching")
    }
}


