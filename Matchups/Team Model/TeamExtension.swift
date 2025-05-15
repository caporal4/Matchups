//
//  TeamExtension.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/5/25.
//

import Foundation

extension Team {
    static var sample: Team {
        let sample = Team(
            id: 10,
            name: "Detroit Pistons",
            nickname: "Pistons",
            code: "DET",
            city: "Detroit",
            logo: "https://media.api-sports.io/basketball/teams/140.png",
            allStar: false,
            nbaFranchise: true,
            leagues: ["Standard": LeagueInfo(conference: "East", division: "Central")]
        )
        return sample
    }
}
