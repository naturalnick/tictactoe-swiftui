//
//  GameSpace.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct PlayerMove: Codable, Transferable {
    var index: Int
    var player: String
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .playerMove)
    }
}

extension UTType {
    static let playerMove = UTType(exportedAs: "com.nickschaefer.playerMove")
}

struct GameSpace: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var spaceIndex: Int
    var spaceWidth: CGFloat
    var spaceColor: Color {
        viewModel.validDragMoves.contains(spaceIndex) ?
            .green : .white
    }
    
    var body: some View {
        ZStack {
            Button {
                if viewModel.selectedGameType == .numerical { return }
                
                if viewModel.selectedGameType == .wild {
                    if spaceIndex == viewModel.chooseIndex {
                        viewModel.chooseIndex = nil
                    } else {
                        viewModel.chooseIndex = spaceIndex
                    }
                } else {
                    viewModel.handlePlayerMove(moveIndex: spaceIndex)
                }
            } label: {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .readRect { rect in
                        if viewModel.spaceRects[spaceIndex] == nil {
                            viewModel.spaceRects[spaceIndex] = rect
                        }
                    }
                    .padding(.all, 5)
                    .foregroundStyle(spaceColor)
                    .shadow(color: Color(.sRGB, white: 0.85, opacity: 1), radius: 8)
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(viewModel.moves[spaceIndex] != nil)
            
            if let player = viewModel.moves[spaceIndex] {
                MoveIndicator(player: player, spaceIndex: spaceIndex, spaceWidth: spaceWidth, gameType: viewModel.selectedGameType, isTurnX: viewModel.isTurnX)
                    .environmentObject(viewModel)
            }
            
//            if (viewModel.chooseIndex == spaceIndex) {
//                ChooseView(spaceIndex: spaceIndex ,spaceWidth: spaceWidth)
//            }
        }
        .frame(width: spaceWidth, height: spaceWidth)
        .zIndex((viewModel.dragOriginIndex ?? -1) == spaceIndex ? 2 : 1)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}

struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

extension View {
    func readRect(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: geometry.frame(in: .global))
            }
        )
        .onPreferenceChange(RectPreferenceKey.self, perform: onChange)
    }
}
