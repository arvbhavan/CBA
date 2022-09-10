//
//  TransactionFlowViewControllerFactoryTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionFlowViewControllerFactoryTests: XCTestCase {

    private var viewControllerFactory: TransactionFlowCoordinator.ViewControllerFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.viewControllerFactory = TransactionFlowCoordinator.ViewControllerFactory()
    }

    override func tearDownWithError() throws {
        self.viewControllerFactory = nil
        try super.tearDownWithError()
    }

    func testMakeTransactionViewController() {
        // Given
        let coordinatorDelegate = MockTransactionListViewModelCoordinatorDelegate()
        let mockTransactionService = MockTransactionService()

        // When
        let viewController = self.viewControllerFactory.makeTransactionListViewController(service: mockTransactionService,
                                                                                          coordinatorDelegate: coordinatorDelegate)

        // Then
        let transactionListViewController = viewController as? TransactionListViewController
        XCTAssertNotNil(transactionListViewController)
    }
    
    func testMakeATMDetailViewController() {
        // Given
        let atmDetail = ATMDetail.makeMock()

        // When
        let viewController = self.viewControllerFactory.makeATMDetailViewController(atmDetail: atmDetail)

        // Then
        let mapViewController = viewController as? ATMMapViewController
        XCTAssertNotNil(mapViewController)
    }
}

