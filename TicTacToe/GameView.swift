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
    
    @State var screenWidth: CGFloat = 392
    
    var body: some View {
        VStack {
            TicTacToolbar().environmentObject(viewModel)
            
            ZStack {
                HStack {
                    ScoreCard(player: "x", isComputer: false).environmentObject(viewModel)
                    
                    ScoreCard(player: "o", isComputer: !viewModel.multiplayerModeOn).environmentObject(viewModel)
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
                            .offset(x: -(screenWidth / 2 / 2), y: 70)

                        ConfettiView(score: $viewModel.oScore)
                            .offset(x: screenWidth / 2 / 2 , y: 70)
                    }
                }
            }
            .zIndex(4)
            .padding()
            
            if viewModel.selectedGameType == .numerical {
                NumberView().environmentObject(viewModel)
            }
            
            GameGrid(screenWidth: screenWidth).environmentObject(viewModel)
            
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
                .scaleEffect(viewModel.isResetButtonVisible ? 1 : 0.1, anchor: .bottom)
            } else if !viewModel.isResetButtonVisible {
                withAnimation(.easeInOut) {
                    Text(viewModel.selectedGameType.rules)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(5)
                        .minimumScaleFactor(0.1)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .background(Color(.sRGB, white: 0.95, opacity: 1))
        .readRect { rect in
            screenWidth = rect.width
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
