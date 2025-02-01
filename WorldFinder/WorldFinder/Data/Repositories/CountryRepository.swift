//
//  CountryRepository.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//


import Foundation
import Combine

class CountryRepository: CountryRepositoryProtocol {
    private let service: CountryServiceProtocol
    private let userDefaults: UserDefaults
    private let countriesKey = "savedCountries"
    private let selectedCountriesKey = "selectedCountries"

    init(service: CountryServiceProtocol = CountryService(), userDefaults: UserDefaults = .standard) {
        self.service = service
        self.userDefaults = userDefaults
    }

    // ✅ Fetches countries (Uses API or Local Cache)
    func getCountries() -> AnyPublisher<[Country], NetworkError> {
        if shouldUseLocalData() {
            return loadCountriesFromCache()
        } else {
            return fetchCountriesFromAPI()
        }
    }

    // ✅ Forces fetching fresh data from API (Bypasses cache)
    func fetchCountriesFromAPI() -> AnyPublisher<[Country], NetworkError> {
        return service.fetchAllCountries(method: .get, body: nil)
            .map { countries in
                self.saveCountriesToCache(countries) // ✅ Save API result in cache
                return countries
            }
            .eraseToAnyPublisher()
    }

    // ✅ Saves countries in UserDefaults
    func saveCountriesToCache(_ countries: [Country]) {
        guard !countries.isEmpty else { return }
        userDefaults.setCodable(countries, forKey: countriesKey)
    }

    // ✅ Loads countries from UserDefaults
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError> {
        if let savedCountries: [Country] = userDefaults.codable(forKey: countriesKey) {
            return Just(savedCountries)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.cacheNotFound).eraseToAnyPublisher()
        }
    }

    // ✅ Saves selected countries
    func saveSelectedCountries(_ selectedCountries: [Country]) {
        guard !selectedCountries.isEmpty else { return }
        userDefaults.setCodable(selectedCountries, forKey: selectedCountriesKey)
    }

    // ✅ Loads selected countries
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError> {
        if let savedSelectedCountries: [Country] = userDefaults.codable(forKey: selectedCountriesKey) {
            return Just(savedSelectedCountries)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.cacheNotFound).eraseToAnyPublisher()
        }
    }

    // ✅ Determines whether to fetch from cache or API
    func shouldUseLocalData() -> Bool {
        let cachedCountries: [Country]? = userDefaults.codable(forKey: countriesKey)
        return !isInternetAvailable() || cachedCountries != nil
    }

    // ✅ Clears cached countries asynchronously
    func clearCachedCountries() -> AnyPublisher<Void, Never> {
        return Future { promise in
            self.userDefaults.removeObject(forKey: self.countriesKey)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    // ✅ Clears selected countries cache asynchronously
    func clearCachedSelectedCountries() -> AnyPublisher<Void, Never> {
        return Future { promise in
            self.userDefaults.removeObject(forKey: self.selectedCountriesKey)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    // ✅ Checks internet connection
    private func isInternetAvailable() -> Bool {
        return NetworkMonitor.shared.isInternetAvailable()
    }
}

