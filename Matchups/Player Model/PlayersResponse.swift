//
//  PlayerResponse.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

class PlayersResponse: Codable {
    var response: [Player]
    
    init(response: [Player]) {
        self.response = response
    }
}
