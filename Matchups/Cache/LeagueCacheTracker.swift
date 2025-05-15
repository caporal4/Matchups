//
//  CacheTracker.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/14/25.
//

import Foundation

class CacheTracker: Codable {
    static var cacheList = [Date]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(cacheList) {
                UserDefaults.standard.set(encoded, forKey: "list")
            }
        }
    }
    
    init() {
        if let savedList = UserDefaults.standard.data(forKey: "list") {
            if let decodedList = try? JSONDecoder().decode([Date].self, from: savedList) {
                CacheTracker.cacheList = decodedList
                return
            }
        }
        CacheTracker.cacheList = []
    }
}
