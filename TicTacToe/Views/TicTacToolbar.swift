//
//  Toolbar.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct TicTacToolbar: ToolbarContent {
    var multiplayerModeOn: Bool
    var toggleMultiplayerMode: () -> Void
    var resetGame: () -> Void
    
    var body: some ToolbarContent {
        PlayerButton(toggleMultiplayerMode: toggleMultiplayerMode, multiplayerModeOn: multiplayerModeOn)
        Title()
        ResetButton(resetGame: resetGame)
    }
}

struct Title: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Tic Tac Toe")
                .font(.system(size: 30, weight: .black, design: .serif))
        }
    }
}

struct ResetButton: ToolbarContent {
    var resetGame: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: resetGame) {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .font(.system(size: 24, weight: .black))
        }
    }
}

struct PlayerButton: ToolbarContent {
    var toggleMultiplayerMode: () -> Void
    var multiplayerModeOn: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: toggleMultiplayerMode) {
                Label("2_Player", systemImage: multiplayerModeOn ? "person.2.fill" : "person.fill")
            }
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .font(.system(size: 24))
            .badge(2)
        }
    }
}
