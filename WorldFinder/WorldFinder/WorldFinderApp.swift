//
//  WorldFinderApp.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//


import SwiftUI

@main
struct WorldFinderApp: App {
    var body: some Scene {
        WindowGroup {
            CountryView(
                viewModel: CountryViewModel(
                    getCountriesUseCase: GetCountriesUseCase(repository: CountryRepository())
                )
            )
        }
    }
}
