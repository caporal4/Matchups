//
//  ContentViewViewModel.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/8/25.
//

import Foundation

extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var teams = TeamsResponse(response: [Team]())
        @Published var baseTeams = TeamsResponse(response: [Team]())
        
        @Published var filterText = ""
        
        let token = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        let URLString = "https://v2.nba.api-sports.io/teams?"
            
        func fetchData() async {
            guard let token else { return }
            guard let header else { return }
            guard let url = URL(string: URLString) else { return }
            
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: header)
            
            let fiveMinutesAgo = Date().addingTimeInterval(-300)

            if !LeagueCacheTracker.cacheList.isEmpty {
                if LeagueCacheTracker.cacheList[0] < fiveMinutesAgo {
                    LeagueCache.shared.removeObject(forKey: "CachedObject")
                }
            }
            
            if let cachedVersion = LeagueCache.shared.object(forKey: "CachedObject") {
                await MainActor.run {
                    teams = cachedVersion
                }
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(TeamsResponse.self, from: data) {
                        teams.response = decodedResponse.response
                            .filter { $0.nbaFranchise == true }
                            .filter { $0.allStar == false }
                            .sorted()
                        baseTeams = teams
                        LeagueCache.shared.setObject(teams, forKey: "CachedObject")
                        LeagueCacheTracker.cacheList.insert(Date.now, at: 0)
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                }
            }
        }

        func filter() {
            teams.response = baseTeams.response.filter { $0.name.lowercased().contains(filterText.lowercased()) }
        }
    }
}
