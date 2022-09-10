//
//  TransactionListViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

/// ViewModel's FlowCoordinator delegate - to propagate navigation requested from the View
protocol TransactionListViewModelCoordinatorDelegate: AnyObject {
    func viewModel(_ viewModel: TransactionListViewModelProtocol, didSelectTransactionWithATMDetail atmDetail: ATMDetail)
}

/// ViewModel's View delegate - to propagate events and state changes back to the view
protocol TransactionListViewModelViewDelegate: AnyObject {
    func viewModelDidChangeState(_ viewModel: TransactionListViewModelProtocol)
}

protocol TransactionListViewModelProtocol: AnyObject {
    var coordinatorDelegate: TransactionListViewModelCoordinatorDelegate? { get }
    var viewDelegate: TransactionListViewModelViewDelegate? { get }
}

final class TransactionListViewModel: TransactionListViewModelProtocol {
    weak var coordinatorDelegate: TransactionListViewModelCoordinatorDelegate?
    weak var viewDelegate: TransactionListViewModelViewDelegate?

    private let service: TransactionServiceProtocol
    
    enum State {
        case loading(Section)
        case success([Section])
        case error(Section)
    }
    
    enum Section {
        case loading(text: String)
        case accountDetail(AccountDetailCellViewModel)
        case transaction(TransactionSectionViewModel)
        case error(text: String)
    }
    
    private enum Strings {
        static let title = "account.details.title"
        static let backButton = "account.details.back.button"
        static let loading = "transaction.loading.title"
        static let serviceError = "transaction.service.error"
    }

    let screenTitleText = Strings.title.localized
    let backButtonText = Strings.backButton.localized
    
    private var state: State {
        didSet {
            viewDelegate?.viewModelDidChangeState(self)
        }
    }

    init(service: TransactionServiceProtocol) {
        self.service = service
        let loadingSection: Section = .loading(text: Strings.loading.localized)
        self.state = .loading(loadingSection)
    }
    
    var sections: [Section] {
        switch state {
        case .loading(let section):
            return [section]
        case .success(let sections):
            return sections
        case .error(let section):
            return [section]
        }
    }
    
    func fetchTransaction() {
        service.fetchTransactions { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                self.state = .success(self.makeTransactionSectionViewModels(from: response))
            case .failure:
                let errorSection: Section = .error(text: Strings.serviceError.localized)
                self.state = .error(errorSection)
            }
        }
    }
    
    func getNumberOfRowsForSection(_ section: Int) -> Int {
        switch sections[section] {
        case .loading, .accountDetail, .error:
            return 1
        case .transaction(let transactionSectionViewModel):
            return transactionSectionViewModel.cellViewModels.count
        }
    }
    
    func handleSelection(at indexPath: IndexPath) {
        guard case .transaction(let transactionSectionViewModel) = sections[indexPath.section] else {
            return
        }
        
        let transactionCellViewModel = transactionSectionViewModel.cellViewModels[indexPath.row]
        guard let atmDetail = transactionCellViewModel.atmDetail else {
            // Only transaction cell's with ATM information can handle selection
            return
        }

        coordinatorDelegate?.viewModel(self, didSelectTransactionWithATMDetail: atmDetail)
    }
}

// MARK: Private helper functions

private extension TransactionListViewModel {
    func makeTransactionSectionViewModels(from response: TransactionResponse) -> [Section] {
        var sections: [Section] = []

        // First section - Account Detail
        let accountDetailCellViewModel = AccountDetailCellViewModel(accountDetail: response.account)
        sections.append(.accountDetail(accountDetailCellViewModel))
        
        // Rest of the sections - Transaction sections grouped by `Date of transaction`
        let atms = response.atms
        let pendingTransactions: [TransactionCellViewModel] = response.pending
            .map {
                TransactionCellViewModel(pending: true, transaction: $0, atmDetail: $0.atmId.flatMap { id in atms[id] })
            }
        let clearedTransactions: [TransactionCellViewModel] = response.transactions
            .map {
                TransactionCellViewModel(pending: false, transaction: $0, atmDetail: $0.atmId.flatMap { id in atms[id] })
            }
        let allTransactions = clearedTransactions + pendingTransactions
        let transactionCellsGroupedByDate: [Date: [TransactionCellViewModel]] = Dictionary(
            grouping: allTransactions,
            by: { $0.transaction.effectiveDate }
        )
        
        var transactionSectionViewModels = [TransactionSectionViewModel]()
        transactionCellsGroupedByDate.keys
            .sorted { $0 > $1 }
            .forEach({
                guard let transactionCells = transactionCellsGroupedByDate[$0] else {
                    return
                }
                return transactionSectionViewModels.append(TransactionSectionViewModel(date: $0, cellViewModels: transactionCells))
            })
        let transactionSections: [Section] = transactionSectionViewModels.map { .transaction($0) }
        sections.append(contentsOf: transactionSections)
        
        return sections
    }
}

// MARK: Helper Utils

private extension Array where Self.Element == ATMDetail {
    
    /// Helper subscript to get an ATMDetail matching `atmId` from an array of ATMDetail's
    subscript(atmId: String) -> ATMDetail? {
        return self.first { $0.id == atmId }
    }
}
