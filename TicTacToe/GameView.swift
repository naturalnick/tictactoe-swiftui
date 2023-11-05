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
                TicTacToolbar(multiplayerModeOn: viewModel.multiplayerModeOn, toggleMultiplayerMode: viewModel.toggleMultiplayerMode, resetGame: viewModel.resetGame, selectedGameType: $viewModel.selectedGameType)
                
                ZStack {
                    HStack {
                        ScoreCard(player: "X", score: $viewModel.xScore, gameStarted: viewModel.xScore + viewModel.oScore > 0, isTurn: viewModel.isTurnX)
                        ScoreCard(player: "O", score: $viewModel.oScore, gameStarted: viewModel.xScore + viewModel.oScore > 0, isComputer: !viewModel.multiplayerModeOn, isTurn: !viewModel.isTurnX)
                    }
                    ZStack {
                        Circle()
                            .stroke(.gray, lineWidth: 3)
                            .background(Circle().fill(.white))
                            .frame(width: 50)
                            .shadow(color: Color(.sRGB, white: 0.75, opacity: 1), radius: 5)
                        
                        Text("VS")
                            .font(.custom("Futura-Bold", size: 20))
                        
                        if viewModel.gameStarted {
                            ConfettiView(score: $viewModel.xScore)
                                .offset(x: -(geometry.size.width / 2 / 2), y: 70)
                            ConfettiView(score: $viewModel.oScore)
                                .offset(x: geometry.size.width / 2 / 2 , y: 70)
                        }
                    }
                }
                .padding()
                
                GameGrid(moves: viewModel.moves, handlePlayerMove: viewModel.handlePlayerMove, handleDrag: viewModel.handleDrag, winner: viewModel.winner, screenWidth: geometry.size.width)
                
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
                        Text(viewModel.selectedGameType.rules)
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(4)
                            .minimumScaleFactor(0.1)
                            .padding()
                    }
                }
                
                Spacer()
            }
            .background(Color(.sRGB, white: 0.95, opacity: 1))
        }
    }
}

struct ConfettiView: View {
    @Binding var score: Int
    
    var body: some View {
        EmptyView()
            .confettiCannon(counter: $score, confettiSize: 18)
    }
}

#Preview {
    GameView()
}
