//
//  CountryViewModel+Caching+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Foundation

extension CountryViewModel {
    
    /// ✅ Saves all countries (Calls Use Case)
    func saveCountries() {
        manageLocalCountriesUseCase.saveCountries(countries)
    }
    
    /// ✅ Loads selected countries (Calls Use Case)
    func loadSelectedCountries() {
        manageLocalCountriesUseCase.loadSelectedCountries()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] countries in
                DispatchQueue.main.async {
                    self?.selectedCountries = countries
                }
            })
            .store(in: &cancellables)
    }
    
    /// ✅ Saves selected countries (Calls Use Case)
    func saveSelectedCountries() {
        manageLocalCountriesUseCase.saveSelectedCountries(selectedCountries)
    }

    /// ✅ Clears cache (Calls Use Case)
    
    func clearCache() {
        DispatchQueue.main.async {
            self.isLoading = true  // ✅ Show loading indicator
        }
        manageLocalCountriesUseCase.clearCache()
            .sink(receiveCompletion: { _ in
                DispatchQueue.main.async {
                    self.countries = [] // ✅ Reset countries so UI updates
                    self.selectedCountries = [] // ✅ Reset selected countries
                    self.isLoading = false // ✅ Hide loading indicator
                    print("✅ Cache cleared successfully!")
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
}
