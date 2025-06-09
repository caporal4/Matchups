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
        
        @Published var isLoading = false
        
        @Published var players = [Player]()
                
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        var URLString: String {
            "https://v2.nba.api-sports.io/players?team=\(team.id)&season=2023"
        }
            
        func fetchData() async {
            isLoading = true
            guard let token else { return }
            guard let header else { return }
            guard let url = URL(string: URLString) else { return }
            
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: header)
            
            let fiveMinutesAgo = Date().addingTimeInterval(-300)

            if !TeamCache.cacheTracker.isEmpty {
                print("Cache tracker has values")
                if TeamCache.cacheTracker[0] < fiveMinutesAgo {
                    print("Cache tracker values are too old, emptyting cache.")
                    TeamCache.shared.removeObject(forKey: NSString(string: team.name))
                }
            }

            if let cachedVersion = TeamCache.shared.object(forKey: NSString(string: team.name)) {
                await MainActor.run {
                    players = cachedVersion.response.sorted()
                    print("Retrieved cached \(team.name).")
                    isLoading = false
                }
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(PlayersResponse.self, from: data) {
                        players = decodedResponse.response
                            .sorted()
                        TeamCache.shared.setObject(decodedResponse, forKey: NSString(string: team.name))
                        print("Cached \(team.name)")
                        TeamCache.cacheTracker.insert(Date.now, at: 0)
                        print("Set the cache tracker")
                        isLoading = false
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                }
            }
        }
        
        init(team: Team) {
            self.team = team
        }
    }
}
