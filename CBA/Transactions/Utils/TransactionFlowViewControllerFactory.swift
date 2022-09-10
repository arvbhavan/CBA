//
//  TransactionFlowViewControllerFactory.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation
import UIKit

/// Factory methods to make the ViewController's required in `TransactionFlowCoordinator` flow
protocol TransactionFlowViewControllerFactory {
    func makeTransactionListViewController(service: TransactionServiceProtocol, coordinatorDelegate: TransactionListViewModelCoordinatorDelegate) -> UIViewController
    func makeATMDetailViewController(atmDetail: ATMDetail) -> UIViewController
}

extension TransactionFlowCoordinator {

    struct ViewControllerFactory: TransactionFlowViewControllerFactory {
        func makeTransactionListViewController(service: TransactionServiceProtocol, coordinatorDelegate: TransactionListViewModelCoordinatorDelegate) -> UIViewController {
            let transactionListViewModel = TransactionListViewModel(service: service)
            transactionListViewModel.coordinatorDelegate = coordinatorDelegate
            
            let transactionListViewController = TransactionListViewController(viewModel: transactionListViewModel)

            return transactionListViewController
        }
        
        func makeATMDetailViewController(atmDetail: ATMDetail) -> UIViewController {
            let atmMapViewModel = ATMMapViewModel(atmDetail: atmDetail)
            let viewController = ATMMapViewController(viewModel: atmMapViewModel)

            return viewController
        }
    }
}
