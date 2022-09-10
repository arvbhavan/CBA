//
//  MockNetworkClient.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class MockNetworkClient<Response>: NetworkClientProtocol {

    var responseToReturn: Response?
    var errorToReturn: Error?

    private(set) var requestConfigurationReceived: RequestConfiguration?
    private(set) var responseConfigurationTypeReceived: Any.Type?
    func performRequest<T: RequestConfiguration, U: ResponseConfiguration>(_ request: T, responseConfigurationType: U.Type, completion: @escaping (Result<U.ResponseModel, Error>) -> Void) {
        requestConfigurationReceived = request
        responseConfigurationTypeReceived = responseConfigurationType
        
        if let error = errorToReturn {
            return completion(.failure(error))
        }
        
        guard let responseToReturn = responseToReturn else {
            fatalError("Should set either `responseToReturn` or `errorToReturn` before calling performRequest(..) method")
        }
        
        guard let response = responseToReturn as? U.ResponseModel else {
            fatalError("Response Model does not match the type requested")
        }
        
        return completion(.success(response))
    }
}
