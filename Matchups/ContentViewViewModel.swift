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
        @Published var westTeams = [Team]()
        @Published var eastTeams = [Team]()
        
        @Published var isLoading = false
        
        @Published var baseTeams = [Team]()
        
        @Published var filterText = ""
        
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        let URLString = "https://v2.nba.api-sports.io/teams?"
            
        func fetchData() async {
            isLoading = true
            guard let token else { return }
            guard let header else { return }
            guard let url = URL(string: URLString) else { return }
            
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: header)
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                if let decodedResponse = try? decoder.decode(TeamsResponse.self, from: data) {
                    baseTeams = decodedResponse.response
                        .filter { $0.nbaFranchise == true }
                        .filter { $0.allStar == false }
                        .sorted()
                    western()
                    eastern()
                    isLoading = false
                }
            } catch {
                print("Decoding failed with error: \(error)")
            }

        }
        func western() {
            westTeams = baseTeams.filter { $0.leagues["standard"]?.conference == "West" }
        }
        
        func eastern() {
            eastTeams = baseTeams.filter { $0.leagues["standard"]?.conference == "East" }
        }

        func filter() {
        }
    }
}
