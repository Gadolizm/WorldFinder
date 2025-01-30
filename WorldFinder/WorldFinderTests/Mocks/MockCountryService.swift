//
//  MockCountryService.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Combine
import Foundation
import XCTest
@testable import WorldFinder

// MARK: - Mock Service
class MockCountryService: CountryServiceProtocol {
    var result: Result<[Country], Error>?
    
    func fetchAllCountries() -> AnyPublisher<[Country], Error> {
        guard let result = result else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}
