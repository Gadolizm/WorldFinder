//
//  CountryRepositoryProtocol 2.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine

import Combine

protocol CountryRepositoryProtocol {
    /// ✅ Fetches countries (Uses API or Cache based on `shouldUseLocalData()`)
    func getCountries() -> AnyPublisher<[Country], NetworkError>

    /// ✅ Fetches fresh countries directly from API (Bypasses cache)
    func fetchCountriesFromAPI() -> AnyPublisher<[Country], NetworkError>

    /// ✅ Saves a list of countries to local storage (for offline support)
    func saveCountriesToCache(_ countries: [Country])

    /// ✅ Loads countries from local storage
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError>

    /// ✅ Clears cached countries from local storage
    func clearCachedCountries() -> AnyPublisher<Void, Never>

    /// ✅ Determines whether cached data should be used instead of an API call
    func shouldUseLocalData() -> Bool

    /// ✅ Saves selected countries to local storage
    func saveSelectedCountries(_ countries: [Country])

    /// ✅ Loads selected countries from local storage
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError>

    /// ✅ Clears cached selected countries from local storage
    func clearCachedSelectedCountries() -> AnyPublisher<Void, Never>
}
