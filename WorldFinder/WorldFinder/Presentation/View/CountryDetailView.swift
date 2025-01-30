//
//  CountryDetailView.swift
//  WorldFinder
//
//  Created by Haitham Gado on 28/01/2025.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Country: \(country.name)").font(.title)
            Text("Capital: \(country.capital ?? "")").font(.callout)

            if let currencies = country.currencies, !currencies.isEmpty {
                ForEach(currencies, id: \.code) { currency in
                    Text("Currencies: \(currency.name) (\(currency.code)) - \(currency.symbol)").font(.callout)
                }
            } else {
                Text("Currencies: No data available")
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
