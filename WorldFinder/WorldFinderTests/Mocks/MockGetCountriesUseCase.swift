//
//  MockGetCountriesUseCase.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Combine
@testable import WorldFinder

class MockGetCountriesUseCase: GetCountriesUseCaseProtocol {
    var result: Result<[Country], NetworkError> = .success([Country.sample])
    
    func execute() -> AnyPublisher<[Country], NetworkError> {
        return result.publisher.eraseToAnyPublisher()
    }
}
