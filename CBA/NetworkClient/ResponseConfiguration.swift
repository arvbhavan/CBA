//
//  ResponseConfiguration.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

protocol ResponseConfiguration {
    associatedtype ResponseModel where ResponseModel: Decodable
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? { get }
}
