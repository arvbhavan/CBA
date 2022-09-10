//
//  TransactionListUITests.swift
//  TransactionListUITests
//
//  Created by Aravind R on 18/09/21.
//

import XCTest

class TransactionListUITests: XCTestCase {

    private var app: CBAApp!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = CBAApp()
        app.launch()
    }

    func testTransactionList() throws {
        let transactionList = try app.getTransactionListScreen()
        
        let accountDetail = try transactionList.getAccountDetail()
        try accountDetail.verifyAccountDetail()

        let clearedTransaction = try transactionList.getTransaction(at: 1, row: 0)
        try clearedTransaction.verifyTransaction(hasLocation: false, pending: false)

        app.swipeUp(velocity: .fast)
        let pendingTransaction = try transactionList.getTransaction(at: 13, row: 0)
        try pendingTransaction.verifyTransaction(hasLocation: false, pending: true)
        
        try pendingTransaction.getATMDetail() // Negative testing to verify a non-location cell does not navigate to ATM detail
        
        let atmTransaction = try transactionList.getTransaction(at: 8, row: 0)
        try atmTransaction.verifyTransaction(hasLocation: true, pending: false)
        
        let atmDetailScreen = try XCTUnwrap(atmTransaction.getATMDetail())
        let atmAnnotation = try XCTUnwrap(atmDetailScreen.tapAnnotation())

        atmAnnotation.verifyLocationDetail(text: "Circular Quay Station, 8 Alfred St, Sydney, NSW 2000")
        
        try atmDetailScreen.navigateBack()
    }
}
