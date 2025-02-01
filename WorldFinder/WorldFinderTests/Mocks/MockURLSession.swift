//
//  MockURLSession.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Foundation
import Combine
@testable import WorldFinder

// MARK: - Mock URLSession for Unit Tests

import Combine
import Foundation

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: URLError?

    init(data: Data? = nil, response: URLResponse? = nil, error: URLError? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }

    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let data = mockData, let response = mockResponse else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        return Just((data, response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
