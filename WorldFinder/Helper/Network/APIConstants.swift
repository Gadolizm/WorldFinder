//
//  APIConstants.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Foundation

struct APIConstants {
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL is not configured in Info.plist")
        }
        return url
    }
    static let allCountriesEndpoint = "/all"
}
