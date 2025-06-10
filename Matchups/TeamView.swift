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
        ZStack {
            Color(
                red: viewModel.teamColorR ?? 0,
                green: viewModel.teamColorG ?? 0,
                blue: viewModel.teamColorB ?? 0
            )
                .opacity(0.75)
                .ignoresSafeArea()
            
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
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ForEach(viewModel.players) { player in
                            NavigationLink(value: player) {
                                Text("\(player.firstname) \(player.lastname)")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle(viewModel.team.name)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Player.self) { player in
                    PlayerView(
                        player: player,
                        teamColorR: viewModel.teamColorR ?? 0,
                        teamColorG: viewModel.teamColorG ?? 0,
                        teamColorB: viewModel.teamColorB ?? 0
                    )
                }
                .toolbarBackground(
                    Color(
                        red: viewModel.teamColorR ?? 0,
                        green: viewModel.teamColorG ?? 0,
                        blue: viewModel.teamColorB ?? 0
                    ),
                    for: .navigationBar, .tabBar
                )
                .task {
                    await viewModel.fetchData()
                    await viewModel.fetchColor()
                }
            }
        }
    }
}

#Preview {
    TeamView(team: .sample)
}
