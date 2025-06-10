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
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                ZStack {
                    Color.PistonsBlue
                        .opacity(0.35)
                        .ignoresSafeArea()
                    List {
                        Section("East") {
                            ForEach(viewModel.eastTeams) { team in
                                NavigationLink(value: team) {
                                    Text(team.name)
                                }
                            }
                        }
                        Section("West") {
                            ForEach(viewModel.westTeams) { team in
                                NavigationLink(value: team) {
                                    Text(team.name)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .toolbarBackground(Color.PistonsBlue.opacity(0.35), for: .navigationBar, .tabBar)
                    .navigationTitle("Matchups")
                    .navigationDestination(for: Team.self) { team in
                        TeamView(team: team)
                    }
                }
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
