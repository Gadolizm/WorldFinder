//
//  CountryService.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Combine
import Foundation

class CountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    /// ✅ Fetch all countries (Supports dynamic HTTP methods)
     func fetchAllCountries(method: HTTPMethod = .get, body: Data? = nil) -> AnyPublisher<[Country], NetworkError> {
         return networkManager.fetchData(
             from: APIConstants.allCountriesEndpoint,
             responseType: [Country].self,
             method: method,
             body: body
         )
     }
}
