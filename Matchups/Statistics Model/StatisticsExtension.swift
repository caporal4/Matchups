//
//  Untitled.swift
//  Matchups
//
//  Created by Brendan Caporale on 6/8/25.
//

extension Statistics {
    static var sample: Statistics {
        let sample = Statistics(
            game: Game(id: 12345),
            points: 23,
            offReb: 2,
            defReb: 3,
            totReb: 5,
            assists: 2,
            steals: 1,
            turnovers: 3,
            blocks: 0,
        )
        return sample
    }
}
