//
//  CountryViewModelProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Foundation
import Combine

protocol CountryViewModelProtocol: ObservableObject {
    /// ✅ List of all countries
    var countries: [Country] { get }
    
    /// ✅ List of selected/favorite countries
    var selectedCountries: [Country] { get }
    
    /// ✅ Tracks loading state (for UI indicators)
    var isLoading: Bool { get }
    
    /// ✅ Holds error messages
    var errorMessage: ErrorMessage? { get set }
    
    /// ✅ Fetches countries (Uses API or Local Storage)
    func getCountries()
    
    /// ✅ Saves fetched countries to local storage
    func saveCountries()
    
    /// ✅ Loads selected/favorite countries
    func loadSelectedCountries()
    
    /// ✅ Saves selected countries
    func saveSelectedCountries()
    
    /// ✅ Clears cached country data
    func clearCache()
}
