//
//  NetworkClientTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class NetworkClientTests: XCTestCase {

    private var mockBaseURL: URL!
    private var mockDataTaskPerformer: MockDataTaskPerformer!

    private var networkClient: NetworkClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        mockBaseURL = URL(string: "https://testserver.com")
        mockDataTaskPerformer = MockDataTaskPerformer()
        networkClient = NetworkClient(baseURL: mockBaseURL, dataTaskPerformer: mockDataTaskPerformer)
    }

    override func tearDownWithError() throws {
        mockBaseURL = nil
        mockDataTaskPerformer = nil
        networkClient = nil
        TestConfiguration.dateDecodingStrategy = nil

        try super.tearDownWithError()
    }

    func testPerformRequestForSuccess() {
        // Given
        mockDataTaskPerformer.expectedCompletionData = String.responseDataWithoutDate
        let mockRequestConfiguration = MockRequestConfiguration(requestPath: "/carDetail", httpMethod: .get)
        let responseConfigurationType = MockResponseConfiguration<CarDetail>.self

        // When
        let expectation = self.expectation(description: "expect a completion of network request")
        var returnedResult: Result<CarDetail, Error>?
        networkClient.performRequest(mockRequestConfiguration, responseConfigurationType: responseConfigurationType) { result in
            returnedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        // Then
        XCTAssertEqual(mockDataTaskPerformer.events.count, 1, "Expected exactly one data task performed")
        guard case .dataTask(request: let urlRequest) = mockDataTaskPerformer.events[0] else {
            XCTFail("Expected a data task event at index 0")
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, "GET", "Invalid http method found in request")
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://testserver.com/carDetail", "Invalid `URL` found in request")
        
        switch returnedResult {
        case .success(let carDetail):
            XCTAssertEqual(carDetail.name, "Tesla")
            XCTAssertEqual(carDetail.yearOfMake, 2020)
        default:
            XCTFail("Expected result of type - \(CarDetail.self)")
        }
    }

    func testPerformRequestForSuccessWhenDateInResponse() {
        // Given
        mockDataTaskPerformer.expectedCompletionData = String.responseDataWithDate
        let mockRequestConfiguration = MockRequestConfiguration(requestPath: "/person", httpMethod: .get)
        let mockDateFormatter = DateFormatter()
        mockDateFormatter.dateFormat = "dd/MM/yyyy"
        TestConfiguration.dateDecodingStrategy = .formatted(mockDateFormatter)

        let responseConfigurationType = MockResponseConfiguration<Person>.self

        // When
        let expectation = self.expectation(description: "expect a completion of network request")
        var returnedResult: Result<Person, Error>?
        networkClient.performRequest(mockRequestConfiguration, responseConfigurationType: responseConfigurationType) { result in
            returnedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertEqual(mockDataTaskPerformer.events.count, 1, "Expected exactly one data task performed")
        guard case .dataTask(request: let urlRequest) = mockDataTaskPerformer.events[0] else {
            XCTFail("Expected a data task event at index 0")
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, "GET", "Invalid http method found in request")
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://testserver.com/person", "Invalid `URL` found in request")

        // Then
        switch returnedResult {
        case .success(let person):
            XCTAssertEqual(person.name, "John Citizen")
            XCTAssertNotNil(person.dateOfBirth)
        default:
            XCTFail("Expected result of type - \(Person.self)")
        }
    }

    func testPerformRequestForFailureWhenDecodingFails() {
        // Given
        mockDataTaskPerformer.expectedCompletionData = String.responseDataWithDate // Set a mismatching response data
        let mockRequestConfiguration = MockRequestConfiguration(requestPath: "/carDetail", httpMethod: .get)
        let responseConfigurationType = MockResponseConfiguration<CarDetail>.self

        // When
        let expectation = self.expectation(description: "expect a completion of network request")
        var returnedResult: Result<CarDetail, Error>?
        networkClient.performRequest(mockRequestConfiguration, responseConfigurationType: responseConfigurationType) { result in
            returnedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        // Then
        switch returnedResult {
        case .failure(let error):
            XCTAssertTrue(error is DecodingError)
        default:
            XCTFail("Expected a response decoding failure")
        }
    }

    func testPerformRequestForFailureWhenDataTaskFails() {
        // Given
        mockDataTaskPerformer.expectedCompletionError = TestError.serviceUnavailable
        let mockRequestConfiguration = MockRequestConfiguration(requestPath: "/carDetail", httpMethod: .get)
        let responseConfigurationType = MockResponseConfiguration<CarDetail>.self

        // When
        let expectation = self.expectation(description: "expect a completion of network request")
        var returnedResult: Result<CarDetail, Error>?
        networkClient.performRequest(mockRequestConfiguration, responseConfigurationType: responseConfigurationType) { result in
            returnedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        // Then
        switch returnedResult {
        case .failure(let error):
            XCTAssertTrue(error is TestError)
        default:
            XCTFail("Expected a response valid error from network")
        }
    }

    func testPerformRequestForFailureWhenURLFormingFails() {
        // Given
        let mockRequestConfiguration = MockRequestConfiguration(requestPath: "invalid path", httpMethod: .get)
        let responseConfigurationType = MockResponseConfiguration<CarDetail>.self

        // When
        let expectation = self.expectation(description: "expect a completion of network request")
        var returnedResult: Result<CarDetail, Error>?
        networkClient.performRequest(mockRequestConfiguration, responseConfigurationType: responseConfigurationType) { result in
            returnedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        // Then
        switch returnedResult {
        case .failure(NetworkClientError.invalidURL):
            // Success
            break
        default:
            XCTFail("Expected a URL forming error")
        }
    }
}

private class MockDataTaskPerformer: DataTaskPerforming {
    enum Event: Equatable {
        case dataTask(request: URLRequest)
    }
    private(set) var events: [Event] = []

    var expectedCompletionData: Data?
    var expectedCompletionError: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        events.append(.dataTask(request: request))
        if let error = expectedCompletionError {
            completionHandler(nil, nil, error)
            return URLSessionDataTask.makeMock()
        }

        if let data = expectedCompletionData {
            completionHandler(data, nil, nil)
            return URLSessionDataTask.makeMock()
        }

        fatalError("Should set either `completionData` or `expetedCompletionError` before calling dataTask(..) method")
    }
}

private extension URLSessionDataTask {
    
    static func makeMock() -> URLSessionDataTask {
        return URLSession(configuration: .default)
            .dataTask(with: URL(string: "https://mockURL")!)
    }
}

private struct MockRequestConfiguration: RequestConfiguration {

    let requestPath: String
    let httpMethod: HTTPMethod
}

private struct MockResponseConfiguration<Model: Decodable>: ResponseConfiguration {

    typealias ResponseModel = Model

    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        TestConfiguration.dateDecodingStrategy
    }
}

private struct TestConfiguration {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
}

private extension String {
    static var responseDataWithoutDate: Data? {
        let responseString = """
            {
                "name": "Tesla",
                "yearOfMake": 2020
            }
            """
        return responseString.data(using: .utf8)
    }

    static var responseDataWithDate: Data? {
        let responseString = """
            {
                "name": "John Citizen",
                "dateOfBirth": "12/08/1987"
            }
            """
        return responseString.data(using: .utf8)
    }
}

// MARK: Test errors

enum TestError: Error {
    case serviceUnavailable
}

// MARK: Models

struct CarDetail: Decodable {
    let name: String
    let yearOfMake: Int
}

struct Person: Decodable {
    let name: String
    let dateOfBirth: Date
}
