//
//  MockManageLocalCountriesUseCase.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Combine
@testable import WorldFinder


class MockManageLocalCountriesUseCase: ManageLocalCountriesUseCaseProtocol {
    var savedCountries: [Country] = []
    var savedSelectedCountries: [Country] = []
    
    func saveCountries(_ countries: [Country]) {
        savedCountries = countries
    }
    
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError> {
        return Just(savedCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func saveSelectedCountries(_ countries: [Country]) {
        savedSelectedCountries = countries
    }
    
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError> {
        return Just(savedSelectedCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func clearCache() -> AnyPublisher<Void, Never> {
        savedCountries.removeAll()
        savedSelectedCountries.removeAll()
        return Just(()).eraseToAnyPublisher()
    }
}
