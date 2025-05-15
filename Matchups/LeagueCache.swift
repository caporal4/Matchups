//
//  LeagueCache.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/14/25.
//

import Foundation

class LeagueCache {
    static let shared = NSCache<NSString, TeamsResponse>()
}
