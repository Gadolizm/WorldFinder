//
//  ManageLocalCountriesUseCaseProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Combine

protocol ManageLocalCountriesUseCaseProtocol {
    func saveCountries(_ countries: [Country])
    func loadCountriesFromCache() -> AnyPublisher<[Country], NetworkError>
    func loadSelectedCountries() -> AnyPublisher<[Country], NetworkError>
    func saveSelectedCountries(_ countries: [Country])
    func clearCache() -> AnyPublisher<Void, Never>
}
