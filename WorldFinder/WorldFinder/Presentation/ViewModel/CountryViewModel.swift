//
//  CountryViewModel.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine
import Foundation
import CoreLocation

class CountryViewModel: NSObject, CountryViewModelProtocol, ObservableObject {
    @Published var countries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var errorMessage: ErrorMessage?                
    @Published var selectedCountry: Country? = nil
    
    let countriesKey = "savedCountries"
    let selectedCountryKey = "selectedCountry"
    
    private let getCountriesUseCase: GetCountriesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    let userDefaults: UserDefaultsProtocol
    
    var locationManager: CLLocationManager?
    private var defaultCountry: Country
    
    init(
        defaultCountry: Country = .defaultCountry,
        getCountriesUseCase: GetCountriesUseCaseProtocol,
        userDefaults: UserDefaultsProtocol = UserDefaults.standard
    ) {
        self.defaultCountry = defaultCountry
        self.getCountriesUseCase = getCountriesUseCase
        self.userDefaults = userDefaults
        super.init()
        setupLocationManager()
        loadCountriesFromUserDefaults()
        loadSelectedCountriesFromUserDefaults()
    }
    
    /// Fetches the list of countries from the REST API.
    
    func fetchCountries() {
        getCountriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
            }
            .store(in: &cancellables)
    }
    
    /// Adds a country to the selected list (max 5 countries).
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else {
            self.errorMessage = ErrorMessage(message: "You can only add up to 5 countries.")
            return
        }
        
        if !selectedCountries.contains(where: { $0.name == country.name }) {
            selectedCountries.append(country)
            saveSelectedCountriesToUserDefaults()
        } else {
            self.errorMessage = ErrorMessage(message: "\(country.name) is already in the selected list.")
        }
    }
    
    /// Removes a country from the selected list.
    func removeCountry(at offsets: IndexSet) {
        selectedCountries.remove(atOffsets: offsets)
        saveSelectedCountriesToUserDefaults()
    }
    
    /// Add a country by its name (if it exists in the list of countries).
    func addCountryByName(_ name: String) {
        if let country = countries.first(where: { $0.name == name }) {
            selectedCountries = [country]
        } else {
            setDefaultCountry()
        }
    }
    
    /// Set the default country.
    func setDefaultCountry() {
        selectedCountries = [defaultCountry]
    }
    
    /// Handles errors and provides user-friendly error messages.
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = ErrorMessage(message: "You appear to be offline. Please check your internet connection.")
            case .timedOut:
                errorMessage = ErrorMessage(message: "The request timed out. Please try again.")
            default:
                errorMessage = ErrorMessage(message: "An unexpected error occurred. Please try again.")
            }
        } else if let decodingError = error as? DecodingError {
            errorMessage = ErrorMessage(message: "Failed to process the data received from the server. Please try again later.")
            print("Decoding Error: \(decodingError)")
        } else {
            errorMessage = ErrorMessage(message: "An unexpected error occurred: \(error.localizedDescription)")
        }
        print("Error: \(error)")
    }
}
