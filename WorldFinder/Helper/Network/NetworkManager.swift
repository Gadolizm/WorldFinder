//
//  NetworkManager.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchData<T: Decodable>(from endpoint: String, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: APIConstants.baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return .decodingFailed
                }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
