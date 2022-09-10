//
//  TransactionResponseConfiguration.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

enum TransactionResponseConfiguration: ResponseConfiguration {
    
    typealias ResponseModel = TransactionResponse
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        .formatted(DateFormatter.serverDateFormatter)
    }
}
