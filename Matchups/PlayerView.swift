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
        List {
            Text(viewModel.player.firstname)
            ForEach(viewModel.statistics) { stat in
                Text(String(stat.points))
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    PlayerView(player: .sample)
}
