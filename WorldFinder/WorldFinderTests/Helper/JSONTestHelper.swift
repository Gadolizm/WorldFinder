//
//  JSONTestHelper.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Foundation

class JSONTestHelper {
    static func loadJSONFile(named filename: String) -> Data? {
        guard let url = Bundle(for: JSONTestHelper.self).url(forResource: filename, withExtension: "json") else {
            print("❌ Could not find \(filename).json in test bundle")
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("❌ Error loading JSON: \(error)")
            return nil
        }
    }
}
