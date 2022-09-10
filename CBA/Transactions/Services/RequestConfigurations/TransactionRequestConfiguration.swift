//
//  TransactionRequestConfiguration.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

struct TransactionRequestConfiguration: RequestConfiguration {
    let requestPath = "/s/tewg9b71x0wrou9/data.json?dl=1"
    
    let httpMethod: HTTPMethod = .get
}
