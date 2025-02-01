//
//  ManageLocalCountriesUseCase.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//


import Combine

class ManageLocalCountriesUseCase: ManageLocalCountriesUseCaseProtocol {
    private let repository: CountryRepositoryProtocol

    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }

    /// ✅ Saves all countries to local storage
    func saveCountries(_ countries: [Country]) {
        repository.saveCountriesToCache(countries)
    }

    /// ✅ Loads all countries from cache
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError> {
        return repository.loadCountriesFromCache()
    }

    /// ✅ Loads selected countries
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError> {
        return repository.loadSelectedCountries()
    }

    /// ✅ Saves selected countries
    func saveSelectedCountries(_ countries: [Country]) {
        repository.saveSelectedCountries(countries)
    }

    /// ✅ Clears cached countries & selected countries asynchronously
    
    func clearCache() -> AnyPublisher<Void, Never> {
        let clearCountries = repository.clearCachedCountries()
        let clearSelectedCountries = repository.clearCachedSelectedCountries()

        return Publishers.Merge(clearCountries, clearSelectedCountries)
            .handleEvents(receiveOutput: { _ in
                print("✅ Cache cleared successfully!") // ✅ Now executes!
            })
            .eraseToAnyPublisher()
    }
}
