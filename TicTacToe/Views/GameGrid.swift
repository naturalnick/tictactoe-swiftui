//
//  GameGrid.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct GameGrid: View {
    private let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    var moves: [String?]
    var handlePlayerMove: (Int) -> Void
    var handleDrag: (Int, Int) -> Void
    var winner: String?
    var screenWidth: CGFloat
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<9) { i in
                GameSpace(spaceIndex: i, screenWidth: screenWidth, handlePlayerMove: handlePlayerMove, handleDrag: handleDrag, moves: moves)
            }
        }
        .disabled(winner != nil)
        .padding(.horizontal, 10)
    }
}
