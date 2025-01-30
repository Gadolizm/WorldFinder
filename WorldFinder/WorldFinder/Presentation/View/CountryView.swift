//
//  CountryView.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import SwiftUI

struct CountryView: View {
    @StateObject var viewModel: CountryViewModel
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                CountryListView(viewModel: viewModel, searchText: searchText)
            }
            .navigationTitle("Countries")
            .onAppear {
                viewModel.loadCountriesFromUserDefaults()
                viewModel.loadSelectedCountriesFromUserDefaults()
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}
