//
//  Country.swift
//  WorldFinder
//
//  Created by Haitham Gado on 24/01/2025.
//

import Foundation

struct Country: Identifiable, Codable {
    let id = UUID()
    let name: String
    let topLevelDomain: [String]?
    let alpha2Code: String
    let alpha3Code: String?
    let callingCodes: [String]
    let capital: String?
    let altSpellings: [String]?
    let subregion: String?
    let region: String
    let population: Int
    let latlng: [Double]?
    let demonym: String
    let area: Double?
    let timezones: [String]
    let borders: [String]?
    let nativeName: String?
    let numericCode: String
    let flags: Flag
    let currencies: [Currency]?
    let languages: [Language]
    let translations: [String: String]
    let flag: String
    let regionalBlocs: [RegionalBloc]?
    let cioc: String?
    let independent: Bool?

    struct Flag: Codable {
        let svg: String
        let png: String
    }

    struct Currency: Codable {
        let code: String
        let name: String
        let symbol: String
    }

    struct Language: Codable {
        let iso639_1: String?
        let iso639_2: String
        let name: String
        let nativeName: String?
    }

    struct RegionalBloc: Codable {
        let acronym: String
        let name: String
    }
}


extension Country {
    static var sample: Country {
        Country(
            name: "France",
            topLevelDomain: [".fr"],
            alpha2Code: "FR",
            alpha3Code: "FRA",
            callingCodes: ["33"],
            capital: "Paris",
            altSpellings: ["FR", "French Republic", "République française"],
            subregion: "Western Europe",
            region: "Europe",
            population: 65273511,
            latlng: [46.0, 2.0],
            demonym: "French",
            area: 551695.0,
            timezones: ["UTC+01:00"],
            borders: ["AND", "BEL", "DEU", "ITA", "LUX", "MCO", "ESP", "CHE"],
            nativeName: "France",
            numericCode: "250",
            flags: Flag(svg: "https://flagcdn.com/fr.svg", png: "https://flagcdn.com/w320/fr.png"),
            currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")],
            languages: [
                Language(iso639_1: "fr", iso639_2: "fra", name: "French", nativeName: "français")
            ],
            translations: ["de": "Frankreich", "es": "Francia", "it": "Francia"],
            flag: "https://flagcdn.com/fr.svg",
            regionalBlocs: [
                RegionalBloc(acronym: "EU", name: "European Union")
            ],
            cioc: "FRA",
            independent: true
        )
    }
}

extension Country {
    static var defaultCountry: Country {
        Country(
            name: "Egypt",
            topLevelDomain: [".eg"],
            alpha2Code: "EG",
            alpha3Code: "EGY",
            callingCodes: ["+20"],
            capital: "Cairo",
            altSpellings: ["EG", "Arab Republic of Egypt", "جمهورية مصر العربية"],
            subregion: "Northern Africa",
            region: "Africa",
            population: 104258327,
            latlng: [26.8206, 30.8025],
            demonym: "Egyptian",
            area: 1002450.0,
            timezones: ["UTC+02:00"],
            borders: ["LBY", "SDN"], 
            nativeName: "مصر",
            numericCode: "818",
            flags: Country.Flag(
                svg: "https://upload.wikimedia.org/wikipedia/commons/f/fe/Flag_of_Egypt.svg",
                png: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Flag_of_Egypt.svg/320px-Flag_of_Egypt.svg.png"
            ),
            currencies: [
                Country.Currency(code: "EGP", name: "Egyptian pound", symbol: "£")
            ],
            languages: [
                Country.Language(iso639_1: "ar", iso639_2: "ara", name: "Arabic", nativeName: "العربية")
            ],
            translations: [
                "de": "Ägypten",
                "es": "Egipto",
                "fr": "Égypte",
                "it": "Egitto"
            ],
            flag: "https://upload.wikimedia.org/wikipedia/commons/f/fe/Flag_of_Egypt.svg",
            regionalBlocs: [
                Country.RegionalBloc(acronym: "AU", name: "African Union")
            ],
            cioc: "EGY",
            independent: true
        )
    }
}
