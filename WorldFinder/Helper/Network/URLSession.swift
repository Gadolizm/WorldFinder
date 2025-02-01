//
//  URLSession.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Foundation
import Combine

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        self.dataTaskPublisher(for: request.url!)
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}
