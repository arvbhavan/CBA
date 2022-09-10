//
//  TransactionCellViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionCellViewModelTests: XCTestCase {

    private var mockTransaction: Transaction!
    private var mockATMDetail: ATMDetail?

    private var viewModel: TransactionCellViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTransaction = Transaction(id: "43243255",
                                      effectiveDate: Date(),
                                      description: "Woolworths shopping",
                                      amount: 40,
                                      atmId: "ATM123")
        mockATMDetail = ATMDetail(id: "ATM123",
                                  name: "Darling Harbour ATM",
                                  address: "77 kent street, NSW, 2000",
                                  location: Location.makeMock())
        viewModel = TransactionCellViewModel(pending: false,
                                             transaction: mockTransaction,
                                             atmDetail: mockATMDetail)
    }

    override func tearDownWithError() throws {
        mockTransaction = nil
        mockATMDetail = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }

    func testHasATMInformationForTrue() {
        XCTAssertTrue(viewModel.hasATMInformation)
    }
    
    func testHasATMInformationForFalse() {
        viewModel = TransactionCellViewModel(pending: false,
                                             transaction: mockTransaction,
                                             atmDetail: nil)
        XCTAssertFalse(viewModel.hasATMInformation)
    }

    func testTransactionDetailWhenTransactionIsPending() {
        XCTAssertEqual(viewModel.transactionDetailText.string, "Woolworths shopping")
    }
    
    func testTransactionDetailWhenTransactionIsCleared() {
        viewModel = TransactionCellViewModel(pending: true,
                                             transaction: mockTransaction,
                                             atmDetail: mockATMDetail)

        let transactionDetailText = viewModel.transactionDetailText
        XCTAssertEqual(transactionDetailText.string, "PENDING: Woolworths shopping")
        
        // Range of highlighted text
        var rangesOfHighlightedText: [NSRange] = []
        transactionDetailText.enumerateAttribute(.pendingTransactionHighlight,
                                                 in: NSRange(location: 0, length: transactionDetailText.length),
                                                 options: []) { attribute, range, _ in
            guard attribute != nil else {
                return
            }
            rangesOfHighlightedText.append(range)
        }
        XCTAssertEqual(rangesOfHighlightedText, [NSRange(location: 0, length: 8)])
    }

    func testBalanceText() {
        XCTAssertEqual(viewModel.balanceText, "A$40.00")
    }
}
