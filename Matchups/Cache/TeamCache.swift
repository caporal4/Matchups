//
//  TeamCache.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/14/25.
//

import Foundation

class TeamCache {
    static let shared = NSCache<NSString, PlayersResponse>()
}
