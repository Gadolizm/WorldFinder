//
//  URLSessionProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import Foundation
import Combine

// MARK: - Protocol for Dependency Injection
protocol URLSessionProtocol {
    func fetchDataPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
