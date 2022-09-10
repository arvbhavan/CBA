//
//  TransactionCellViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct TransactionCellViewModel {
    
    private enum Strings {
        static let pending = "PENDING:"
    }
    
    private let pending: Bool
    let transaction: Transaction
    let atmDetail: ATMDetail?
    
    init(pending: Bool, transaction: Transaction, atmDetail: ATMDetail?) {
        self.pending = pending
        self.transaction = transaction
        self.atmDetail = atmDetail
    }

    var hasATMInformation: Bool {
        atmDetail != nil
    }

    var transactionDetailText: NSAttributedString {
        let description = transaction.description
            .replacingHTMLLineBreaks
        guard pending == true else {
            return NSAttributedString(string: description)
        }
        
        let pendingPrefix = Strings.pending.localized
        let attributedString = NSAttributedString(string: "\(pendingPrefix) \(description)")
        return attributedString
            .markText(pendingPrefix, with: .pendingTransactionHighlight)
    }

    var balanceText: String? {
        let decimalNumber = NSDecimalNumber(decimal: transaction.amount)
        return NumberFormatter.currency.string(from: decimalNumber)
    }

    var cellAccessibilityText: String {
        [transactionDetailText.string, balanceText]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

extension NSAttributedString.Key {
    static let pendingTransactionHighlight: NSAttributedString.Key = NSAttributedString.Key(rawValue: "pendingTransactionHighlight")
}

extension String {
    var replacingHTMLLineBreaks: String {
        self.replacingOccurrences(of: "<br/>", with: "\n")
    }
}
