
//
//  CountryListView.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import SwiftUI

struct CountryListView: View {
    @ObservedObject var viewModel: CountryViewModel
    var searchText: String

    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        List {
            // Selected Countries Section
            Section(header: Text("Selected Countries")) {
                ForEach(viewModel.selectedCountries) { country in
                    NavigationLink(destination: CountryDetailView(country: country)) {
                        VStack(alignment: .leading) {
                            Text(country.name).font(.headline)
                            Text("Capital: \(country.capital ?? "")").font(.subheadline)
                            Text("Currency: \(country.currencies?.first?.name ?? "")").font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: viewModel.removeCountry)
                .contentShape(Rectangle()) 
            }
            
            // All Countries Section
            Section(header: Text("All Countries")) {
                ForEach(filteredCountries) { country in
                    Button(action: { viewModel.addCountry(country) }) {
                        VStack(alignment: .leading) {
                            Text(country.name).font(.headline)
                            Text("Capital: \(country.capital ?? "")").font(.subheadline)
                            Text("Currency: \(country.currencies?.first?.name ?? "")").font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}
