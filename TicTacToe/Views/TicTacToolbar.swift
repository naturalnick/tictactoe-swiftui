//
//  Toolbar.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct TicTacToolbar: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Button {
                    viewModel.toggleMultiplayerMode()
                } label: {
                    Image(systemName: viewModel.multiplayerModeOn ? "person.2.fill" : "person.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 26))
                        .frame(width: 60, height: 60)
                }
                .padding(.leading)
                
                Spacer()
                
                Menu {
                    Picker("Tic Tac Toe Variants", selection: $viewModel.selectedGameType) {
                        ForEach(GameType.allCases) { type in
                            Text(type.title)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedGameType.title)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .foregroundStyle(.black)
                    .font(.system(size: 21, weight: .semibold))
                }
                
                Spacer()
                
                Button {
                    viewModel.resetGame()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(.black)
                        .font(.system(size: 24, weight: .black))
                        .frame(width: 60, height: 60)
                }
                .padding(.trailing)
            }
        }
        .background(.white)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}
