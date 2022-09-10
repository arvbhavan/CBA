//
//  String+Localized.swift
//  CBA
//
//  Created by Aravind R on 19/09/21.
//

import Foundation

extension String {
  var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
