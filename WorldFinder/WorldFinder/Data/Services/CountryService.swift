//
//  CountryService.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Combine
import Foundation


class CountryService: CountryServiceProtocol {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchAllCountries() -> AnyPublisher<[Country], Error> {
        let urlString = APIConstants.baseURL + APIConstants.allCountriesEndpoint
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.fetchDataPublisher(for: url)
            .map(\.data)
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
