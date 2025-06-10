//
//  TeamViewViewModel.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/9/25.
//

import Foundation

extension TeamView {
    @MainActor
    class ViewModel: ObservableObject {
        var team: Team
            
        @Published var players = [Player]()

        @Published var teamColorR: Double?
        @Published var teamColorG: Double?
        @Published var teamColorB: Double?

        @Published var isLoading = false
                
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        var URLString: String {
            "https://v2.nba.api-sports.io/players?team=\(team.id)&season=2023"
        }
            
        func fetchData() async {
            isLoading = true
            
            guard let request = buildRequest() else { return }
            
            checkCacheTracker()
            
            if let cachedVersion = TeamCache.shared.object(forKey: NSString(string: team.name)) {
                players = cachedVersion.response.sorted()
                print("Retrieved cached \(team.name).")
                isLoading = false
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(PlayersResponse.self, from: data) {
                        players = decodedResponse.response
                            .sorted()
                        setCacheAndCacheTracker(decodedResponse)
                        isLoading = false
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                }
            }
        }
        
        func buildRequest() -> URLRequest? {
            guard let token else { return nil }
            guard let header else { return nil }
            guard let url = URL(string: URLString) else { return nil }
            
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: header)
            
            return request
        }
        
        func setCacheAndCacheTracker(_ response: PlayersResponse) {
            TeamCache.shared.setObject(response, forKey: NSString(string: team.name))
            print("Cached \(team.name)")
            TeamCache.cacheTracker.insert(Date.now, at: 0)
            print("Set the cache tracker")
        }
        
        func checkCacheTracker() {
            let fiveMinutesAgo = Date().addingTimeInterval(-300)

            if !TeamCache.cacheTracker.isEmpty {
                print("Cache tracker has values")
                if TeamCache.cacheTracker[0] < fiveMinutesAgo {
                    print("Cache tracker values are too old, emptyting cache.")
                    TeamCache.shared.removeObject(forKey: NSString(string: team.name))
                }
            }
        }
        
        func fetchColor() async {
            var teamColors = [TeamColor]()
            var currentTeamColor: TeamColor?
            var rgbArrayDouble: [Double] = []

            teamColors = Bundle.main.decode("teams.json")
            
            if let index = teamColors.firstIndex(where: { $0.name == team.name }) {
                currentTeamColor = teamColors[index]
            }
            
            if let rgbString = currentTeamColor?.colors["rgb"]?[0] {
                let rgbArrayString = rgbString.split(separator: " ")
                rgbArrayDouble = rgbArrayString.map { Double($0) ?? 0.0 }
            }
            
            teamColorR = rgbArrayDouble[0] / 255
            teamColorG = rgbArrayDouble[1] / 255
            teamColorB = rgbArrayDouble[2] / 255
        }
        
        init(team: Team) {
            self.team = team
        }
    }
}
