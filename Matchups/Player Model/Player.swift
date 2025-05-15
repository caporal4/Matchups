//
//  Player.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

struct Player: Codable, Comparable, Equatable, Hashable, Identifiable {
    var id: Int?
    var firstname: String
    var lastname: String
    var birth: Birth
    var nba: Career
    var height: Height
    var weight: Weight
    var college: String?
    var affiliation: String?
    var leagues: [String: PlayerLeague]
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.firstname == rhs.firstname
    }
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.firstname < rhs.firstname
    }
    
    static func > (lhs: Player, rhs: Player) -> Bool {
        return lhs.firstname > rhs.firstname
    }
}
