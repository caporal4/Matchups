//
//  PlayerExtension.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

extension Player {
    static var sample: Player {
        let sample = Player(
            id: 2801,
            firstname: "Cade",
            lastname: "Cunningham",
            birth: Birth(),
            nba: Career(start: 2021, pro: 0),
            height: Height(),
            weight: Weight(),
            college: "Oklahoma State",
            affiliation: "Oklahoma State/USA",
            leagues:["Standard": PlayerLeague(jersey: 2, active: true, pos: "G")]
        )
        return sample
    }
}
