//
//  ContentView.swift
//  Matchups
//
//  Created by Brendan Caporale on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        let viewModel = ViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.teams) { team in
                    NavigationLink(value: team) {
                        Text(team.name)
                    }
                }
            }
            .navigationDestination(for: Team.self) { team in
                TeamView(team: team)
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    ContentView()
}
