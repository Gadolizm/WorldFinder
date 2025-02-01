//
//  NetworkError.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case cacheNotFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "The request failed."
        case .decodingFailed:
            return "Failed to decode the response."
        case .cacheNotFound:
            return "No cached data found."  
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
