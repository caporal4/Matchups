//
//  PlayerViewViewModel.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/13/25.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var viewModel: ViewModel
        
    init(player: Player) {
        let viewModel = ViewModel(player: player)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if let name = viewModel.imageName {
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
                    Text("Points Per Game: \(String(describing: viewModel.ppg))")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("\(viewModel.player.firstname) \(viewModel.player.lastname)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    PlayerView(player: .sample)
}
