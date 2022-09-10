//
//  DateFormatter+Helpers.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

extension DateFormatter {
    static var serverDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.australia
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }
    
    static var mediumStyledDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.calendar = Calendar.australia
        
        return dateFormatter
    }
}
