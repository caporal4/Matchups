//
//  PlayerViewViewModel.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var viewModel: ViewModel
        
    var teamColorR: Double
    var teamColorG: Double
    var teamColorB: Double
    
    init(player: Player, teamColorR: Double, teamColorG: Double, teamColorB: Double) {
        self.teamColorR = teamColorR
        self.teamColorG = teamColorG
        self.teamColorB = teamColorB
        let viewModel = ViewModel(player: player)
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        ZStack {
            Color(red: teamColorR, green: teamColorG, blue: teamColorB)
                .opacity(0.75)
                .ignoresSafeArea()
            VStack {
                if let name = viewModel.imageName,
                   !name.isEmpty,
                   UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                List {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Section {
                            Text("Points Per Game: \(String(describing: viewModel.pointsPerGame))")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Assists Per Game: \(String(describing: viewModel.assistsPerGame))")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Rebounds Per Game: \(String(describing: viewModel.reboundsPerGame))")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Steals Per Game: \(String(describing: viewModel.stealsPerGame))")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("\(viewModel.player.firstname) \(viewModel.player.lastname)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(
                    Color(
                        red: teamColorR,
                        green: teamColorG,
                        blue: teamColorB
                    ),
                    for: .navigationBar, .tabBar
                )
                .task {
                    await viewModel.fetchData()
                }
            }
        }
    }
}

#Preview {
    PlayerView(player: .sample, teamColorR: 237/255, teamColorG: 23/255, teamColorB: 76/255)
}
