//
//  NetworkClient.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

// MARK: Interface replication of URLsession->dataTask

protocol DataTaskPerforming {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

// Dependency Inversion to force `DataTaskPerforming` conformance on Standard `URLSession`
extension URLSession: DataTaskPerforming { }

/// Error representation for possible errors in network client
enum NetworkClientError: Error {
    case invalidURL
}

protocol NetworkClientProtocol {

    /// Peforms an asynchronous network request with the passed in request configuration
    /// - Parameters:
    ///   - request: request confiration for the network call - gives relative path and type information for the expected response
    ///   - completion: closure to be called when the asynchronous network call finishes
    func performRequest<T: RequestConfiguration, U: ResponseConfiguration>(_ request: T, responseConfigurationType: U.Type, completion: @escaping (Result<U.ResponseModel, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {

    private let baseURL: URL
    private let dataTaskPerformer: DataTaskPerforming

    init(baseURL: URL,
         dataTaskPerformer: DataTaskPerforming = URLSession.shared) {
        self.baseURL = baseURL
        self.dataTaskPerformer = dataTaskPerformer
    }
    
    func performRequest<T: RequestConfiguration, U: ResponseConfiguration>(_ request: T, responseConfigurationType: U.Type, completion: @escaping (Result<U.ResponseModel, Error>) -> Void) {
        do {
            let urlRequest = try makeURLRequest(request: request, withBaseURL: baseURL)
            let dataTask = dataTaskPerformer.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard let self = self else {
                    return
                }

                self.handleResponse(for: responseConfigurationType, data: data, error: error, completion: completion)
            }
            dataTask.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

private extension NetworkClient {
    func makeURLRequest<T: RequestConfiguration>(request: T, withBaseURL baseURL: URL) throws -> URLRequest {
        guard let fullURL = URL(string: request.requestPath, relativeTo: baseURL) else {
            throw NetworkClientError.invalidURL
        }

        var urlRequest = URLRequest(url: fullURL)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = request.httpMethodString

        return urlRequest
    }
    
    func handleResponse<U: ResponseConfiguration>(for responseConfigurationType: U.Type, data: Data?, error: Error?, completion: @escaping (Result<U.ResponseModel, Error>) -> Void) {
        DispatchQueue.main.async {
            switch (data, error) {
            case (.some(let responseData), nil):
                do {
                    let jsonDecoder = JSONDecoder()
                    responseConfigurationType.dateDecodingStrategy.map { jsonDecoder.dateDecodingStrategy = $0 }
                    
                    let responseModel = try jsonDecoder.decode(responseConfigurationType.ResponseModel.self, from: responseData)
                    return completion(.success(responseModel))
                } catch {
                    return completion(.failure(error))
                }
            case (_, .some(let responseError)):
                return completion(.failure(responseError))
            case (.none, .none):
                break
            }
        }
    }
}
