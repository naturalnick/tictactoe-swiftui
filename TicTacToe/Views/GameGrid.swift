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
    var spaceWidth: CGFloat {
        return (screenWidth - 20) / 3
    }
    
    @State var columns: [GridItem] = [GridItem(.flexible()),
                                      GridItem(.flexible()),
                                      GridItem(.flexible())]
    
    func getZIndex(forRange range: ClosedRange<Int>) -> Double {
        if let dragOriginIndex = viewModel.dragOriginIndex {
            return range.contains(dragOriginIndex) ? 2 : 1
        }
        if let chooseIndex = viewModel.chooseIndex {
            return range.contains(chooseIndex) ? 2 : 1
        }
        
        return 0
    }
    
    var body: some View {
        VStack (spacing: 1) {
            HStack (spacing: 1) {
                ForEach(0..<3) { spaceIndex in
                    GameSpace(spaceIndex: spaceIndex, spaceWidth: spaceWidth)
                        .environmentObject(viewModel)
                }
            }
            .zIndex(getZIndex(forRange: 0...2))
            
            HStack (spacing: 1) {
                ForEach(3..<6) { spaceIndex in
                    GameSpace(spaceIndex: spaceIndex, spaceWidth: spaceWidth)
                        .environmentObject(viewModel)
                    
                }
            }
            .zIndex(getZIndex(forRange: 3...5))
            
            HStack (spacing: 1) {
                ForEach(6..<9) { spaceIndex in
                    GameSpace(spaceIndex: spaceIndex, spaceWidth: spaceWidth)
                        .environmentObject(viewModel)
                }
            }
            .zIndex(getZIndex(forRange: 6...8))
        }
        .disabled(viewModel.winner != nil)
    }
}
