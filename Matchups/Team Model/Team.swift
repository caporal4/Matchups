//
//  Team.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/5/25.
//

import Foundation

struct Team: Codable, Comparable, Equatable, Hashable, Identifiable {
    var id: Int
    var name: String
    var nickname: String
    var code: String
    var city: String?
    var logo: String?
    var allStar: Bool
    var nbaFranchise: Bool
    var leagues: [String: LeagueInfo]

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func > (lhs: Team, rhs: Team) -> Bool {
        return lhs.name > rhs.name
    }
}
