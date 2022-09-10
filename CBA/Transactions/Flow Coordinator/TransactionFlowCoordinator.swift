//
//  TransactionFlowCoordinator.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation
import UIKit

/// Flow Coordinator for Transactions
///
/// Description
/// - shows transaction list for both cleared and pending transactions
/// - shows atm location details on the map
final class TransactionFlowCoordinator {

    // MARK: Private constant's and var's

    private let serviceFactory: ServiceFactoryProtocol
    private let viewControllerFactory: TransactionFlowViewControllerFactory

    private var flowCompletionHandler: (() -> Void)?
    private var flowNavigationController: UINavigationController

    // MARK: Init's and public facing interfaces

    init(flowNavigationController: UINavigationController,
         serviceFactory: ServiceFactoryProtocol,
         viewControllerFactory: TransactionFlowViewControllerFactory = TransactionFlowCoordinator.ViewControllerFactory()) {
        self.flowNavigationController = flowNavigationController
        self.serviceFactory = serviceFactory
        self.viewControllerFactory = viewControllerFactory
    }

    func startFlow(presentationHandler: (UIViewController) -> Void, completionHandler: @escaping () -> Void) {
        self.flowCompletionHandler = completionHandler

        let transactionService = serviceFactory.makeTransactionService()
        let transactionListViewController = viewControllerFactory.makeTransactionListViewController(service: transactionService, coordinatorDelegate: self)
        flowNavigationController.setViewControllers([transactionListViewController], animated: true)

        presentationHandler(flowNavigationController)
    }
}

// MARK: TransactionListViewModelCoordinatorDelegate implementation

extension TransactionFlowCoordinator: TransactionListViewModelCoordinatorDelegate {
    func viewModel(_ viewModel: TransactionListViewModelProtocol, didSelectTransactionWithATMDetail atmDetail: ATMDetail) {
        let atmMapViewController = viewControllerFactory.makeATMDetailViewController(atmDetail: atmDetail)
        flowNavigationController.pushViewController(atmMapViewController, animated: true)
    }
}
