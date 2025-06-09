//
//  PlayerViewViewModel.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import Foundation

extension PlayerView {
    @MainActor
    class ViewModel: ObservableObject {
        var player: Player
        
        @Published var isLoading = false

        @Published var statistics = [Statistics]()
        
        @Published var ppg = 0.0
        @Published var imageName: String?
                
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        var URLString: String {
            "https://v2.nba.api-sports.io/players/statistics?id=\(player.id ?? 0)&season=2023"
        }
            
        func fetchData() async {
            isLoading = true
            guard let token else { return }
            guard let header else { return }
            guard let url = URL(string: URLString) else { return }
            
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: header)
            
            let fiveMinutesAgo = Date().addingTimeInterval(-300)

            if !PlayerCache.cacheTracker.isEmpty {
                print("Cache tracker has values")
                if PlayerCache.cacheTracker[0] < fiveMinutesAgo {
                    print("Cache tracker values are too old, emptyting cache.")
                    PlayerCache.shared.removeObject(forKey: NSString(string: "\(player.firstname)\(player.lastname)"))
                }
            }

            if let cachedVersion = PlayerCache.shared.object(
                forKey: NSString(string: "\(player.firstname)\(player.lastname)")
            ) {
                await MainActor.run {
                    statistics = cachedVersion.response
                    print("Retrieved cached \(player.firstname)\(player.lastname) stats.")
                    isLoading = false
                }
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(StatisticsResponse.self, from: data) {
                        statistics = decodedResponse.response
                        PlayerCache.shared.setObject(
                            decodedResponse,
                            forKey: NSString(string: "\(player.firstname)\(player.lastname)")
                        )
                        print("Cached \(player.firstname)\(player.lastname) stats.")
                        PlayerCache.cacheTracker.insert(Date.now, at: 0)
                        print("Set the cache tracker")
                        isLoading = false
                        averagePPG()
                        createImage()
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                }
            }
        }
        
        func averagePPG() {
            var pointTotal = 0
            for stat in statistics {
                pointTotal += stat.points
            }
            ppg = Double(pointTotal/statistics.count)
        }
        
        func createImage() {
            imageName = "\(player.firstname)-\(player.lastname)"
        }
        
        init(player: Player) {
            self.player = player
        }
    }
}
