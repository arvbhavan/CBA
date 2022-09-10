//
//  TransactionSectionViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct TransactionSectionViewModel {
    
    let cellViewModels: [TransactionCellViewModel]
    let sectionHeaderViewModel: TransactionSectionHeaderViewModel
    
    init(date: Date, cellViewModels: [TransactionCellViewModel]) {
        self.cellViewModels = cellViewModels
        self.sectionHeaderViewModel = TransactionSectionHeaderViewModel(date: date)
    }
}
