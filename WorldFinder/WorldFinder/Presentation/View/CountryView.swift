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
                // ✅ Show Loading Indicator While Fetching Data
                if viewModel.isLoading {
                    ProgressView("Loading Countries...") // 🔄 Shows when data is loading
                        .padding()
                } else {
                    // ✅ Search Bar for Filtering
                    SearchBar(searchText: $searchText)
                    
                    // ✅ Country List
                    CountryListView(viewModel: viewModel, searchText: searchText)
                }
            }
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        refreshCountries()
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise") // 🔄 Refresh Button
                    }
                    .disabled(viewModel.isLoading) // ✅ Disable refresh button while loading
                }
            }
            .onAppear {
                viewModel.getCountries()
                viewModel.loadSelectedCountries()
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    /// ✅ Clears Cache & Fetches Fresh Data
    private func refreshCountries() {
        viewModel.clearCache() // ✅ Clear Cached Data
        viewModel.getCountries() // ✅ Fetch New Data
    }
}
