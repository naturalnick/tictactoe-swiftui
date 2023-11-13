//
//  GameGrid.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct GameGrid: View {
    @EnvironmentObject var viewModel: GameViewModel
    var screenWidth: CGFloat
    
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible()),
                                       GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<9) { i in
                GameSpace(spaceIndex: i, screenWidth: screenWidth)
                    .zIndex(viewModel.dragOriginIndex == i ? 2 : 1)
            }
        }
        .disabled(viewModel.winner != nil)
        .padding(.horizontal, 10)
    }
}
