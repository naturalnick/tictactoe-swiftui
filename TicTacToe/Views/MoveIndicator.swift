//
//  MoveIndicator.swift
//  TicTacToe
//
//  Created by Nick Schaefer on 1/19/24.
//

import SwiftUI

struct MoveIndicator: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    @State var dragSize = CGSize(width: 0, height: 0)
    
    var player: String
    var spaceIndex: Int
    var spaceWidth: CGFloat
    var gameType: GameType
    var isTurnX: Bool
    
    func dragGesture() -> some Gesture {
        return DragGesture(coordinateSpace: .global)
            .onChanged({ value in
                if (viewModel.dragOriginIndex != spaceIndex) {
                    viewModel.dragOriginIndex = spaceIndex
                }

                dragSize = value.translation
            })
            .onEnded({ value in
                Task {
                    if let dropIndex = indexOfContainingRect(point: value.location, in: viewModel.spaceRects), viewModel.dragValid(from: spaceIndex, to: dropIndex) {
                        viewModel.handleDrag(from: spaceIndex, to: dropIndex)
                    } else {
                        await animate(duration: 0.3) {
                            dragSize = CGSize(width: 0, height: 0)
                        }
                    }
                    
                    viewModel.dragOriginIndex = nil
                }
            })
    }
    
    var body: some View {
        if gameType.moveable {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: spaceWidth/1.6))
                .padding(.horizontal)
                .animation(.easeIn, value: player)
                .offset(dragSize)
                .gesture([spaceIndex, nil].contains(viewModel.dragOriginIndex) ? dragGesture() : nil)
                .zIndex(3)
        } else {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: spaceWidth/1.6))
        }
    }
}

extension View {
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: duration)) {
                execute()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
}
