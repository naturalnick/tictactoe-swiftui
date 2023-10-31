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
    
    var body: some View {
        VStack {
            HStack {
                Button(action: toggleMultiplayerMode) {
                    Label("2_Player", systemImage: multiplayerModeOn ? "person.2.fill" : "person.fill")
                }
                .labelStyle(.iconOnly)
                .foregroundColor(.primary)
                .font(.system(size: 24))
                .frame(width: 50)
                
                Spacer()
                
                Text("Tic Tac Toe")
                    .font(.custom("Futura-Bold", size: 24))
                
                Spacer()
                
                Button(action: resetGame) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .labelStyle(.iconOnly)
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .black))
                .frame(width: 50)
            }
            .shadow(radius: 40)
            .padding()
            
            LinearGradient(colors: [Color(.sRGB, white: 0.85, opacity: 1), Color(.sRGB, white: 0.95, opacity: 1)], startPoint: .top, endPoint: .bottom)
                   .frame(height: 10)
                   .opacity(0.8)
        }
        .background(.white)
    }
}
