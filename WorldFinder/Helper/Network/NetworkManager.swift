//
//  NetworkManager.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Foundation
import Combine

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(
        from endpoint: String,
        responseType: T.Type,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: APIConstants.baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let urlError = error as? URLError {
                    return .requestFailed 
                } else if error is DecodingError {
                    return .decodingFailed
                }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
