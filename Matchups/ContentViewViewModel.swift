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
        @Published var teams = [Team]()
        @Published var westTeams = [Team]()
        @Published var eastTeams = [Team]()
        
        @Published var isLoading = false
        
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        let URLString = "https://v2.nba.api-sports.io/teams?"
            
        func fetchData() async {
            isLoading = true
            
            guard let request = buildRequest() else { return }
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                if let decodedResponse = try? decoder.decode(TeamsResponse.self, from: data) {
                    filterTeams(from: decodedResponse)
                    isLoading = false
                }
            } catch {
                print("Decoding failed with error: \(error)")
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
        
        func filterTeams(from response: TeamsResponse) {
            teams = response.response
                .filter { $0.nbaFranchise == true }
                .filter { $0.allStar == false }
                .sorted()
            westTeams = teams.filter { $0.leagues["standard"]?.conference == "West" }
            eastTeams = teams.filter { $0.leagues["standard"]?.conference == "East" }

        }
    }
}
