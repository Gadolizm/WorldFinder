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
    
    init(service: CountryServiceProtocol = CountryService()) {
        self.service = service
    }
    
    func getCountries() -> AnyPublisher<[Country], Error> {
        return service.fetchAllCountries()
    }
}
