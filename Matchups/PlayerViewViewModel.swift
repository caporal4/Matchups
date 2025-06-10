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
        
        @Published var statistics = [Statistics]()
        
        @Published var isLoading = false
        
        @Published var pointsPerGame = 0.0
        @Published var reboundsPerGame = 0.0
        @Published var assistsPerGame = 0.0
        @Published var stealsPerGame = 0.0
        @Published var imageName: String?
                
        let token = Bundle.main.object(forInfoDictionaryKey: "Token") as? String
        let header = Bundle.main.object(forInfoDictionaryKey: "Header") as? String
        
        var URLString: String {
            "https://v2.nba.api-sports.io/players/statistics?id=\(player.id ?? 0)&season=2023"
        }
            
        func fetchData() async {
            isLoading = true

            guard let request = buildRequest() else { return }

            if let cachedVersion = PlayerCache.shared.object(
                forKey: NSString(string: "\(player.firstname)\(player.lastname)")
            ) {
                statistics = cachedVersion.response
                print("Retrieved cached \(player.firstname) \(player.lastname) stats.")
                createImageAndStats()
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(StatisticsResponse.self, from: data) {
                        statistics = decodedResponse.response
                        setCacheAndCacheTracker(decodedResponse)
                        createImageAndStats()
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
        
        func checkCacheTracker() {
            let fiveMinutesAgo = Date().addingTimeInterval(-300)

            if !PlayerCache.cacheTracker.isEmpty {
                print("Cache tracker has values")
                if PlayerCache.cacheTracker[0] < fiveMinutesAgo {
                    print("Cache tracker values are too old, emptyting cache.")
                    PlayerCache.shared.removeObject(forKey: NSString(string: "\(player.firstname)\(player.lastname)"))
                }
            }
        }
        
        func setCacheAndCacheTracker(_ response: StatisticsResponse) {
            PlayerCache.shared.setObject(
                response,
                forKey: NSString(string: "\(player.firstname)\(player.lastname)")
            )
            print("Cached \(player.firstname) \(player.lastname) stats.")
            PlayerCache.cacheTracker.insert(Date.now, at: 0)
            print("Set the cache tracker")
        }
        
        func createImageAndStats() {
            createImage()
            calculatePointsPerGame()
            calculateReboundsPerGame()
            calculateAssistsPerGame()
            calculateStealsPerGame()
            isLoading = false
        }
        
        func calculatePointsPerGame() {
            var pointTotal = 0
            for stat in statistics {
                pointTotal += stat.points
            }
            pointsPerGame = Double(pointTotal/statistics.count)
        }
        
        func calculateReboundsPerGame() {
            var reboundTotal = 0
            for stat in statistics {
                reboundTotal += stat.totReb
            }
            reboundsPerGame = Double(reboundTotal/statistics.count)
        }
        
        func calculateAssistsPerGame() {
            var assistTotal = 0
            for stat in statistics {
                assistTotal += stat.assists
            }
            assistsPerGame = Double(assistTotal/statistics.count)
        }
        
        func calculateStealsPerGame() {
            var stealsTotal = 0
            for stat in statistics {
                stealsTotal += stat.steals
            }
            stealsPerGame = Double(stealsTotal/statistics.count)
        }
        
        func createImage() {
            imageName = "\(player.firstname)-\(player.lastname)"
        }
        
        init(player: Player) {
            self.player = player
        }
    }
}
