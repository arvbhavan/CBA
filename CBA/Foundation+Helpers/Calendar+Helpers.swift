//
//  Calendar+Helpers.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

extension Calendar {
    static var australia: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en-AU")
        
        return calendar
    }
}
