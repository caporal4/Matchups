//
//  TeamView.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/5/25.
//

import SwiftUI

struct TeamView: View {
    @StateObject private var viewModel: ViewModel
        
    init(team: Team) {
        let viewModel = ViewModel(team: team)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.team.logo ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            List {
                ForEach(viewModel.players) { player in
                    NavigationLink(value: player) {
                        Text("\(player.firstname) \(player.lastname)")
                    }
                }
            }
            .navigationDestination(for: Player.self) { player in
                PlayerView(player: player)
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    TeamView(team: .sample)
}
