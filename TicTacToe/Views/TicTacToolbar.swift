//
//  Toolbar.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct TicTacToolbar: View {
    var multiplayerModeOn: Bool
    var toggleMultiplayerMode: () -> Void
    var resetGame: () -> Void
    var score: Int = 0
    @Binding var selectedGameType: GameType
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Button {
                    toggleMultiplayerMode()
                } label: {
                    Image(systemName: multiplayerModeOn ? "person.2.fill" : "person.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 26))
                        .frame(width: 60, height: 60)
                }
                .padding(.leading)
                
                Spacer()
                
                Menu {
                    Picker("Tic Tac Toe Variants", selection: $selectedGameType) {
                        ForEach(GameType.allCases) { type in
                            Text(type.title)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedGameType.title)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .foregroundStyle(.black)
                    .font(.system(size: 21, weight: .semibold))
                }
                
                Spacer()
                
                Button {
                    resetGame()
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
