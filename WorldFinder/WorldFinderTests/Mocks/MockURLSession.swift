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

class MockURLSession: URLSessionProtocol {
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: URLError?

    init(data: Data?, response: URLResponse?, error: URLError?) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    
    func fetchDataPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let data = mockData, let response = mockResponse else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
