//
//  AccountDetailCellViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class AccountDetailCellViewModelTests: XCTestCase {

    private var mockAccountDetail: AccountDetail!
    private var viewModel: AccountDetailCellViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAccountDetail = AccountDetail(accountName: "Complete Access",
                                          accountNumber: "123456 7895 45623",
                                          available: 100,
                                          balance: 120)
        viewModel = AccountDetailCellViewModel(accountDetail: mockAccountDetail)
    }

    override func tearDownWithError() throws {
        mockAccountDetail = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }

    func testViewModel() {
        XCTAssertEqual(viewModel.accountName, "Complete Access")
        XCTAssertEqual(viewModel.accountNumber, "123456 7895 45623")
        XCTAssertEqual(viewModel.availableFundsTitle, "Available funds")
        XCTAssertEqual(viewModel.availableFundsText, "A$100.00")
        XCTAssertEqual(viewModel.accountBalanceTitle, "Account balance")
        XCTAssertEqual(viewModel.accountBalanceText, "A$120.00")
        XCTAssertEqual(viewModel.cellAccessibilityText, "Complete Access, 123456 7895 45623, Available funds, A$100.00, Account balance, A$120.00")
    }
}
