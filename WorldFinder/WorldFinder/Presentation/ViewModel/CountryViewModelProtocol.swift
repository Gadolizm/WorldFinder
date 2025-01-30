//
//  Untitled.swift
//  WorldFinder
//
//  Created by Haitham Gado on 25/01/2025.
//

import Foundation

protocol CountryViewModelProtocol: ObservableObject {
    var countries: [Country] { get }
    var errorMessage: ErrorMessage? { get set }
    func fetchCountries()
}
