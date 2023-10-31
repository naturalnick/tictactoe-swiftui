//
//  ContentView.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI
import ConfettiSwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TicTacToolbar(multiplayerModeOn: viewModel.multiplayerModeOn, toggleMultiplayerMode: viewModel.toggleMultiplayerMode, resetGame: viewModel.resetGame)
                
                ZStack {
                    HStack {
                        ScoreCard(player: "X", score: $viewModel.xScore, gameStarted: viewModel.xScore + viewModel.oScore > 0, isTurn: viewModel.isTurnX)
                        ScoreCard(player: "O", score: $viewModel.oScore, gameStarted: viewModel.xScore + viewModel.oScore > 0, isComputer: !viewModel.multiplayerModeOn, isTurn: !viewModel.isTurnX)
                    }
                    ZStack {
                        Circle()
                            .stroke(.gray, lineWidth: 5)
                            .background(Circle().fill(.white))
                            .frame(width: 50)
                            .shadow(color: Color(.sRGB, white: 0.75, opacity: 1), radius: 5)
                        
                        Text("VS")
                            .font(.custom("Futura-Bold", size: 20))
                    }
                }
                .padding()
                
                GameGrid(columns: viewModel.columns, moves: viewModel.moves, handlePlayerMove: viewModel.handlePlayerMove, winner: viewModel.winner, geometry: geometry)
                
                Spacer()
                
                if let winner = viewModel.winner {
                    let result = winner == "" ? "Draw!" : "\(winner.uppercased()) Wins!"
                    Button {
                        viewModel.resetGame()
                    } label: {
                        Text(result + " - Play Again?")
                            .font(.custom("Futura-Bold", size: 20))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .onAppear {
                        withAnimation(.spring) {
                            viewModel.isResetButtonVisible = true
                        }
                    }
                    .onDisappear() {
                        withAnimation(.easeOut) {
                            viewModel.isResetButtonVisible = false
                        }
                    }
                    .scaleEffect(viewModel.isResetButtonVisible ? 1 : 0, anchor: .bottom)
                } else if !viewModel.isResetButtonVisible {
                    withAnimation(.easeInOut) {
                        Text("Get 3 in a row to win!")
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                }
                
                Spacer()
            }
            
            .background(Color(.sRGB, white: 0.95, opacity: 1))
        }
    }
}

#Preview {
    GameView()
}
