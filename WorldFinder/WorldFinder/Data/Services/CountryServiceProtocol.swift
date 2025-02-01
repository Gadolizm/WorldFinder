//
//  CountryServiceProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Combine
import Foundation

protocol CountryServiceProtocol {
    func fetchAllCountries(method: HTTPMethod, body: Data?) -> AnyPublisher<[Country], NetworkError>
}
