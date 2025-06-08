//
//  TeamsResponse.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/5/25.
//

import Foundation

class TeamsResponse: Codable {
    var response: [Team]
    
    init(response: [Team]) {
        self.response = response
    }
}
