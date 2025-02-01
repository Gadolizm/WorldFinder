//
//  URLSessionProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError>
}
