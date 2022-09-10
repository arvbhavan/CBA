//
//  TransactionSectionHeaderViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct TransactionSectionHeaderViewModel {
    
    private let date: Date
    private let currentDate: Date

    init(date: Date, currentDate: Date = Date()) {
        self.date = date
        self.currentDate = currentDate
    }
    
    var dateString: String {
        DateFormatter.mediumStyledDateFormatter.string(from: date)
    }
    
    var timelineText: String? {
        guard let days = Calendar.australia.dateComponents([.day], from: date, to: currentDate).day else {
            return nil
        }
        
        let format = NSLocalizedString("%d Day(s) Ago", comment: "")
        return String(format: format, days)
    }

    var cellAccessibilityText: String? {
        return [dateString, timelineText]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
