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
    var mockCountries: [Country] = []
    var mockSelectedCountries: [Country] = []
    var mockError: NetworkError?

    /// ✅ Simulates fetching countries from API
    func fetchCountriesFromAPI() -> AnyPublisher<[Country], NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(mockCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    /// ✅ Simulates saving countries to cache (does nothing in a mock)
    func saveCountriesToCache(_ countries: [Country]) {
        self.mockCountries = countries // ✅ Stores the data in-memory for testing
    }

    /// ✅ Simulates loading countries from cache
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError> {
        if mockCountries.isEmpty {
            return Fail(error: .cacheNotFound).eraseToAnyPublisher()
        }
        return Just(mockCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    /// ✅ Simulates loading selected countries
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError> {
        if mockSelectedCountries.isEmpty {
            return Fail(error: .cacheNotFound).eraseToAnyPublisher()
        }
        return Just(mockSelectedCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    /// ✅ Simulates saving selected countries
    func saveSelectedCountries(_ countries: [Country]) {
        self.mockSelectedCountries = countries // ✅ Stores in-memory
    }

    /// ✅ Fetches all countries (Mocks `getCountries()`)
    func getCountries() -> AnyPublisher<[Country], NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(mockCountries)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func clearCachedCountries() -> AnyPublisher<Void, Never> {
        mockCountries = []
        return Just(()).eraseToAnyPublisher()
    }

    func clearCachedSelectedCountries() -> AnyPublisher<Void, Never> {
        mockSelectedCountries = []
        return Just(()).eraseToAnyPublisher()
    }

    func shouldUseLocalData() -> Bool {
        return !mockCountries.isEmpty
    }
}
