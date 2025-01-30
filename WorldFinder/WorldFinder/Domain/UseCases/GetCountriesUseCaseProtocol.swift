//
//  Untitled.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine

protocol GetCountriesUseCaseProtocol {
    func execute() -> AnyPublisher<[Country], Error>
}
