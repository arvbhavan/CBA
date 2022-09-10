//
//  TransactionFlowCoordinatorTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionFlowCoordinatorTests: XCTestCase {

    private var mockNavigationController: MockNavigationController!
    private var mockServiceFactory: MockServiceFactory!
    private var mockViewControllerFactory: MockTransactionFlowViewControllerFactory!

    private var flowCoordinator: TransactionFlowCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNavigationController = MockNavigationController()
        mockServiceFactory = MockServiceFactory()
        mockViewControllerFactory = MockTransactionFlowViewControllerFactory()
        
        flowCoordinator = TransactionFlowCoordinator(flowNavigationController: mockNavigationController, serviceFactory: mockServiceFactory, viewControllerFactory: mockViewControllerFactory)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockNavigationController = nil
        mockServiceFactory = nil
        mockViewControllerFactory = nil
        flowCoordinator = nil
    }

    func testStartFlowPresentation() {
        // Given
        let mockTransactionListViewController = UIViewController()
        mockViewControllerFactory.viewControllerToReturn = mockTransactionListViewController

        // When
        let expectation = self.expectation(description: "Expect to call presentation handler for the flow")
        var viewControllerToPresent: UINavigationController?
        flowCoordinator.startFlow { viewController in
            viewControllerToPresent = viewController as? UINavigationController
            expectation.fulfill()
        } completionHandler: {
            // No handling required
        }

        waitForExpectations(timeout: 2)

        // Then
        XCTAssertEqual(viewControllerToPresent, mockNavigationController)
        XCTAssertEqual(mockNavigationController.events, [
            .setViewControllers(viewControllers: [mockTransactionListViewController], animated: true)
        ])
        XCTAssertEqual(mockServiceFactory.events, [
            .makeTransactionService
        ])
        XCTAssertEqual(mockViewControllerFactory.events, [
            .makeTransactionListViewController
        ])
    }

    // Tests for TransactionListViewModelCoordinatorDelegate callbacks

    func testDidSelectTransactionWithATMDetail() {
        // Given
        let mockViewController = UIViewController()
        let atmDetail = ATMDetail.makeMock()
        let mockTransactionListViewModel = MockTransactionListViewModel()
        mockViewControllerFactory.viewControllerToReturn = mockViewController
        
        // When
        flowCoordinator.viewModel(mockTransactionListViewModel, didSelectTransactionWithATMDetail: atmDetail)
        
        // Then
        XCTAssertEqual(mockViewControllerFactory.events, [
            .makeATMDetailViewController
        ])
        XCTAssertEqual(mockNavigationController.events, [
            .pushViewController(viewController: mockViewController, animated: true)
        ])
    }
}

class MockTransactionListViewModelCoordinatorDelegate: TransactionListViewModelCoordinatorDelegate {
    enum Event {
        case didSelectTransactionWithATMDetail(ATMDetail)
    }
    private(set) var events: [Event] = []
    
    func viewModel(_ viewModel: TransactionListViewModelProtocol, didSelectTransactionWithATMDetail atmDetail: ATMDetail) {
        events.append(.didSelectTransactionWithATMDetail(atmDetail))
    }
}

private class MockServiceFactory: ServiceFactoryProtocol {
    enum Event {
        case makeTransactionService
    }
    private(set) var events: [Event] = []

    func makeTransactionService() -> TransactionServiceProtocol {
        events.append(.makeTransactionService)
        return MockTransactionService()
    }
}

private class MockTransactionFlowViewControllerFactory: TransactionFlowViewControllerFactory {
    enum Event {
        case makeTransactionListViewController
        case makeATMDetailViewController
    }
    private(set) var events: [Event] = []
    
    var viewControllerToReturn: UIViewController?
    
    func makeTransactionListViewController(service: TransactionServiceProtocol, coordinatorDelegate: TransactionListViewModelCoordinatorDelegate) -> UIViewController {
        events.append(.makeTransactionListViewController)
        guard let viewControllerToReturn = viewControllerToReturn else {
            fatalError("Should set `viewControllerToReturn` before calling makeTransactionListViewController(..)")
        }
        return viewControllerToReturn
    }
    
    func makeATMDetailViewController(atmDetail: ATMDetail) -> UIViewController {
        events.append(.makeATMDetailViewController)
        guard let viewControllerToReturn = viewControllerToReturn else {
            fatalError("Should set `viewControllerToReturn` before calling makeATMDetailViewController(..)")
        }
        return viewControllerToReturn
    }
    
}

private class MockNavigationController: UINavigationController {
    enum Event: Equatable {
        case setViewControllers(viewControllers: [UIViewController], animated: Bool)
        case pushViewController(viewController: UIViewController, animated: Bool)
    }
    private(set) var events: [Event] = []

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        events.append(.setViewControllers(viewControllers: viewControllers, animated: animated))
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        events.append(.pushViewController(viewController: viewController, animated: animated))
    }
}

private class MockTransactionListViewModel: TransactionListViewModelProtocol {
    var viewDelegate: TransactionListViewModelViewDelegate?
    
    var coordinatorDelegate: TransactionListViewModelCoordinatorDelegate?
}
