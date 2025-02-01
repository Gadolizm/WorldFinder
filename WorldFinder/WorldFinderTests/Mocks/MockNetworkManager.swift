//
//  MockNetworkManager.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import XCTest
import Combine
@testable import WorldFinder

/// ✅ Mock `NetworkManager` to simulate API calls
class MockNetworkManager: NetworkManagerProtocol {
    var mockData: Data?
    var mockError: NetworkError?
    
    func fetchData<T: Decodable>(
        from endpoint: String,
        responseType: T.Type,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) -> AnyPublisher<T, NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let data = mockData else {
            return Fail(error: .requestFailed).eraseToAnyPublisher()
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedData)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .decodingFailed).eraseToAnyPublisher()
        }
    }
}
