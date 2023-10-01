//
//  ContentView.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
 
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Spacer()
                    
                    StatusLabel(winner: viewModel.winner, isTurnX: viewModel.isTurnX)
                    
                    Spacer()
                    
                    GameGrid(columns: viewModel.columns, moves: viewModel.moves, handlePlayerMove: viewModel.handlePlayerMove, winner: viewModel.winner, proxy: geometry)
                    
                    Spacer()
                }
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    TicTacToolbar(multiplayerModeOn: viewModel.multiplayerModeOn, toggleMultiplayerMode: viewModel.toggleMultiplayerMode, resetGame: viewModel.resetGame)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
