//
//  Untitled.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine

class GetCountriesUseCase: GetCountriesUseCaseProtocol {
    private let repository: CountryRepositoryProtocol

    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Country], Error> {
        return repository.getCountries()
    }
}
