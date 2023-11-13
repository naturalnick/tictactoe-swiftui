//
//  ScoreCard.swift
//  TicTacToe
//
//  Created by Nick on 10/15/23.
//

import ConfettiSwiftUI
import SwiftUI

struct ScoreCard: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var player: String
    var isComputer: Bool
    
    var isTurn: Bool {
        if (player == "x" && viewModel.isTurnX) || (player == "o" && !viewModel.isTurnX) { return true }
        return false
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(player.uppercased())")
                        .font(.custom("Futura-Bold", size: 40))
                    
                    if viewModel.xScore + viewModel.oScore > 0 {
                        Text("-")
                            .font(.custom("Futura-Bold", size: 24))
                        Text(player == "x" ? "\(viewModel.xScore)" : "\(viewModel.oScore)")
                            .font(.custom("Futura-Bold", size: 24))
                    }
                }
                .animation(.easeIn, value: viewModel.gameStarted)
                
                Text(isComputer ? "Computer" : " ")
                    .font(.custom("Futura", size: 18))
                    .foregroundColor(.gray)
                    .offset(y: -4)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(content: {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(isTurn ? .green : .white, lineWidth: 5)
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).fill(.white))
            })
            .cornerRadius(10)
            .shadow(color: Color(.sRGB, white: 0.85, opacity: 1), radius: 8)
            
            if viewModel.selectedGameType.threePieceLimit {
                let remainingPieces: Int = player == "x" ? viewModel.xPieceCount : viewModel.oPieceCount
                VStack {
                    Text(remainingPieces > 0 ? player : " ")
                        .font(.custom("Futura-Bold", size: 20))
                    Text(remainingPieces > 1 ? player : " ")
                        .font(.custom("Futura-Bold", size: 20))
                    Text(remainingPieces > 2 ? player : " ")                       
                        .font(.custom("Futura-Bold", size: 20))
                }
                .offset(x: player == "x" ? -65 : 65)
            }
        }
    }
}
