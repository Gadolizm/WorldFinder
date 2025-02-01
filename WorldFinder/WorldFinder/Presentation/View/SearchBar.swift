//
//  SearchBar.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import SwiftUI


struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search Countries", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            if !searchText.isEmpty {
                Button("Cancel") {
                    searchText = ""
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.horizontal)
    }
}
