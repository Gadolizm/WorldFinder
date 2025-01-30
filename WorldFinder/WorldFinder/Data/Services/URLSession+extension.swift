//
//  URLSession+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Foundation
import Combine


// MARK: - URLSession Extension to Conform to Protocol
extension URLSession: URLSessionProtocol {
    func fetchDataPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return self.dataTaskPublisher(for: url)
            .map { ($0.data, $0.response) } // Convert DataTaskPublisher output to expected tuple
            .mapError { $0 as URLError } // Ensure the error type matches URLError
            .eraseToAnyPublisher()
    }
}
