//
//  GameGrid.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct GameGrid: View {
    var columns: [GridItem]
    var moves: [String?]
    var handlePlayerMove: (Int) -> Void
    var winner: String?
    var geometry: GeometryProxy
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<9) { i in
                GameSpace(spaceIndex: i, proxy: geometry, handlePlayerMove: handlePlayerMove, moves: moves)
            }
        }
        .disabled(winner != nil)
        .padding(.horizontal, 10)
    }
}
