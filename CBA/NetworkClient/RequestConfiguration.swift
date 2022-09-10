//
//  RequestConfiguration.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol RequestConfiguration {

    var requestPath: String { get }
    
    var httpMethod: HTTPMethod { get }
}

extension RequestConfiguration {
    var httpMethodString: String {
        return httpMethod.rawValue
    }
}
