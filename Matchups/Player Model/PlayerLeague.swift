//
//  PlayerLeague.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

struct PlayerLeague: Codable, Hashable {
    var jersey: Int?
    var active: Bool
    var pos: String?
}
