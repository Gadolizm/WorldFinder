//
//  NetworkManagerProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Combine
import Foundation

/// ✅ Defines methods for networking (Used for mocking in tests)
protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(
        from endpoint: String,
        responseType: T.Type,
        method: HTTPMethod,
        body: Data?
    ) -> AnyPublisher<T, NetworkError>
}
