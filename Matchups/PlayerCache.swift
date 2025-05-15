//
//  PlayerCache.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/14/25.
//

import Foundation

class PlayerCache {
    static let shared = NSCache<NSString, StatisticsResponse>()
}

