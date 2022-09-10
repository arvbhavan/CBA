//
//  TransactionSectionViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionSectionViewModelTests: XCTestCase {

    private var mockDate: Date!
    private var viewModel: TransactionSectionViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let calendar = Calendar.australia
        let dateComponents = DateComponents(calendar: calendar, year: 2021, month: 9, day: 19)
        mockDate = calendar.date(from: dateComponents)

        viewModel = TransactionSectionViewModel(date: mockDate, cellViewModels: mockCellViewModels)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockDate = nil
        viewModel = nil
    }

    func testCellViewModels() {
        XCTAssertEqual(viewModel.cellViewModels.count, 3)
    }

    func testSectionHeaderViewModel() {
        XCTAssertNotNil(viewModel.sectionHeaderViewModel)
    }
}

private extension TransactionSectionViewModelTests {
    var mockCellViewModels: [TransactionCellViewModel] {
        var cellViewModels: [TransactionCellViewModel] = []
        
        let calendar = Calendar.australia
        let dateComponents = DateComponents(calendar: calendar, year: 2021, month: 9, day: 19)
        let date = calendar.date(from: dateComponents)!

        // Transaction 1
        let transaction1 = Transaction(id: "43243255",
                                       effectiveDate: date,
                                       description: "Woolworths shopping",
                                       amount: 40,
                                       atmId: nil)
        let transactionCell1 = TransactionCellViewModel(pending: false, transaction: transaction1, atmDetail: nil)
        cellViewModels.append(transactionCell1)

        // Transaction 2
        let transaction2 = Transaction(id: "1543555",
                                       effectiveDate: date,
                                       description: "Coles Shop",
                                       amount: 34.79,
                                       atmId: nil)
        let transactionCell2 = TransactionCellViewModel(pending: false, transaction: transaction2, atmDetail: nil)
        cellViewModels.append(transactionCell2)

        // Transaction 3
        let atmDetail = ATMDetail(id: "ATM123",
                                  name: "Darling Harbour ATM",
                                  address: "77 kent street, NSW, 2000",
                                  location: Location.makeMock())
        let transaction3 = Transaction(id: "6546346",
                                       effectiveDate: date,
                                       description: "Coffee - Starbucks",
                                       amount: 5.45,
                                       atmId: atmDetail.id)
        let transactionCell3 = TransactionCellViewModel(pending: false, transaction: transaction3, atmDetail: atmDetail)
        cellViewModels.append(transactionCell3)
        
        return cellViewModels
    }
}
