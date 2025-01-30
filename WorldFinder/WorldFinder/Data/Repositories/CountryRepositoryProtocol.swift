//
//  CountryRepositoryProtocol 2.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine


protocol CountryRepositoryProtocol {
    func getCountries() -> AnyPublisher<[Country], Error>
}
