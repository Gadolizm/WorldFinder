//
//  MockCountryRepository.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Combine
import XCTest
@testable import WorldFinder

// MARK: - Mock Repository
class MockCountryRepository: CountryRepositoryProtocol {
    var result: Result<[Country], Error>?

    func getCountries() -> AnyPublisher<[Country], Error> {
        guard let result = result else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
