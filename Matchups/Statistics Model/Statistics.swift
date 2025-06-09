//
//  Statistics.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

struct Statistics: Codable {
    var game: Game
    var points: Int
    var offReb: Int
    var defReb: Int
    var totReb: Int
    var assists: Int
    var steals: Int
    var turnovers: Int
    var blocks: Int
}
