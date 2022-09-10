//
//  TransactionListViewController.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

final class TransactionListViewController: UITableViewController {

    private let viewModel: TransactionListViewModel
    
    init(viewModel: TransactionListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        self.viewModel.viewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.screenTitleText
        navigationItem.backButtonTitle = viewModel.backButtonText

        configureView()
        viewModel.fetchTransaction()
    }

    private func configureView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "\(TransactionListViewController.self).tableView"

        tableView.register(ErrorTableViewCell.self)
        tableView.register(LoadingTableViewCell.self)
        tableView.register(AccountDetailTableViewCell.self)
        tableView.register(TransactionTableViewCell.self)
        tableView.register(TransactionSectionHeaderView.self)
    }

}

// MARK: UITableViewDataSource methods

extension TransactionListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsForSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .loading(text: let loadingText):
            let loadingCell = tableView.dequeue(LoadingTableViewCell.self, for: indexPath)
            loadingCell.configure(loadingText: loadingText)
            
            return loadingCell
        case .accountDetail(let accountCellViewModel):
            let accountDetailCell = tableView.dequeue(AccountDetailTableViewCell.self, for: indexPath)
            accountDetailCell.configure(with: accountCellViewModel, indexPath: indexPath)
            
            return accountDetailCell
        case .transaction(let transactionSectionViewModel):
            let transactionCellViewModel = transactionSectionViewModel.cellViewModels[indexPath.row]
            let transactionCell = tableView.dequeue(TransactionTableViewCell.self, for: indexPath)
            transactionCell.configure(with: transactionCellViewModel, indexPath: indexPath)
            
            return transactionCell
        case .error(text: let errorMessage):
            let errorCell = tableView.dequeue(ErrorTableViewCell.self, for: indexPath)
            errorCell.configure(errorMessage: errorMessage)
            
            return errorCell
        }
    }
}

// MARK: UITableViewDelegate methods

extension TransactionListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelection(at: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .loading, .error:
            return tableView.bounds.height
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .transaction(let transactionSectionViewModel):
            let transactionSectionHeaderViewModel = transactionSectionViewModel.sectionHeaderViewModel
            let transactionSectionHeaderView = tableView.dequeue(TransactionSectionHeaderView.self)
            transactionSectionHeaderView.configure(with: transactionSectionHeaderViewModel, section: section)
            
            return transactionSectionHeaderView
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .transaction:
            return UITableView.automaticDimension
            
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
}

// MARK: TransactionListViewModelViewDelegate implementation

extension TransactionListViewController: TransactionListViewModelViewDelegate {
    func viewModelDidChangeState(_ viewModel: TransactionListViewModelProtocol) {
        tableView.reloadData()
    }
}
