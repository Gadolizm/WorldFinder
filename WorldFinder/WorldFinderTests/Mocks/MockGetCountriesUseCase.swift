//
//  MockGetCountriesUseCase.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Combine
import XCTest
import CoreLocation
@testable import WorldFinder


// MARK: - Mock GetCountriesUseCase
class MockGetCountriesUseCase: GetCountriesUseCaseProtocol {
    var result: Result<[Country], Error>?

    func execute() -> AnyPublisher<[Country], Error> {
        guard let result = result else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
