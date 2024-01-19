//
//  ChooseView.swift
//  TicTacToe
//
//  Created by Nick Schaefer on 11/13/23.
//

import SwiftUI

struct ChooseView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var spaceIndex: Int
    var spaceWidth: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: "bubble.middle.top.fill")
                .resizable()
                .frame(width: spaceWidth, height: spaceWidth)
                .foregroundStyle(.gray)
                .overlay(
                    Image(systemName: "bubble.middle.top.fill")
                        .resizable()
                        .frame(width: spaceWidth - 4, height: spaceWidth - 4)
                        .foregroundStyle(.white)
                )
            VStack {
                Text("Pick")
                    .font(.custom("Futura-Bold", size: 14))
                HStack {
                    Button(action: {
                        viewModel.handlePlayerMove(moveIndex: spaceIndex, piece: "x")
                        viewModel.chooseIndex = nil
                    }, label: {
                        Text("X")
                    })
                    Button(action: {
                        viewModel.handlePlayerMove(moveIndex: spaceIndex, piece: "o")
                        viewModel.chooseIndex = nil
                    }, label: {
                        Text("O")
                    })
                }
                .tint(.primary)
                .buttonStyle(.bordered)
                .font(.custom("Futura-Bold", size: 24))
            }
            .offset(y: 7)
        }
        .offset(y: spaceWidth / 2)    }
}
