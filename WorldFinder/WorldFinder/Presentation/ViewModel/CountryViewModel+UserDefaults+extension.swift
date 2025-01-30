//
//  CountryViewModel+UserDefaults+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Foundation

extension CountryViewModel {
    
    func saveCountriesToUserDefaults() {
        userDefaults.setCodable(countries, forKey: countriesKey)
    }
    
    func saveSelectedCountriesToUserDefaults() {
        userDefaults.setCodable(selectedCountries, forKey: selectedCountryKey)
    }
    
    func loadCountriesFromUserDefaults() {
        if let savedCountries: [Country] = userDefaults.codable(forKey: "savedCountries") {
            countries = savedCountries
        } else {
            print("No saved data in UserDefaults, skipping API call in Unit Tests")
        }
    }
    
    func loadSelectedCountriesFromUserDefaults() {
        if let savedCountries: [Country] = UserDefaults.standard.codable(forKey: selectedCountryKey) {
            selectedCountries = savedCountries
        }
    }
}
