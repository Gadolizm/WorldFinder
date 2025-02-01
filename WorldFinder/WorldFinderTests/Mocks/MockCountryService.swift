//
//  MockCountryService.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Combine
import Foundation
@testable import WorldFinder

// MARK: - Mock Service

class MockCountryService: CountryServiceProtocol {
    var mockCountries: [Country] = []
    var mockError: NetworkError?

    func fetchAllCountries(method: HTTPMethod = .get, body: Data? = nil) -> AnyPublisher<[Country], NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(mockCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
