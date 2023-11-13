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
    var screenWidth: CGFloat
    
    var spaceWidth: CGFloat {
        return (screenWidth - 20) / 3
    }
    
    var spaceColor: Color {
        viewModel.isDragging && viewModel.validDragMoves.contains(spaceIndex) ?
            .green : .white
    }
    
    var body: some View {
        ZStack {
            Button {
                viewModel.handlePlayerMove(moveIndex: spaceIndex)
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
            }
        }
        .frame(width: spaceWidth, height: spaceWidth)
    }
}

struct MoveIndicator: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    @State var position: CGPoint? = nil
    
    var player: String
    var spaceIndex: Int
    var spaceWidth: CGFloat
    var gameType: GameType
    var isTurnX: Bool
    
    private var initialPosition: CGPoint {
        CGPoint(x: spaceWidth / 2, y: spaceWidth / 2)
    }
    
    func indexOfContainingRect(point: CGPoint, in rects: [CGRect?]) -> Int? {
        for (index, rect) in rects.enumerated() {
            if rect!.contains(point) {
                return index
            }
        }
        return nil
    }
    
    var body: some View {
        if gameType.moveable {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: spaceWidth/1.6))
                .padding(.horizontal)
                .animation(.easeIn, value: player)
                .position(position ?? initialPosition)
                .readRect(in: .local) { rect in
                    position = CGPoint(x: rect.width / 2, y: rect.height / 2)
                }
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged({ value in
                            if viewModel.isDragging && viewModel.dragOriginIndex != spaceIndex { return }
                            
                            viewModel.dragOriginIndex = spaceIndex
                            viewModel.isDragging = true
                            
                            if position != nil {
                                position?.x = initialPosition.x + value.translation.width
                                position?.y = initialPosition.y + value.translation.height
                            }
                        })
                        .onEnded({ value in
                            Task {
                                if let dropIndex = indexOfContainingRect(point: value.location, in: viewModel.spaceRects), viewModel.dragValid(from: spaceIndex, to: dropIndex) {
                                    viewModel.handleDrag(from: spaceIndex, to: dropIndex)
                                } else {
                                    await animate(duration: 0.3) {
                                        position = initialPosition }
                                }
                                
                                viewModel.isDragging = false
                                viewModel.dragOriginIndex = nil
                            }
                        }))
        } else {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: spaceWidth/1.6))
        }
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
    func readRect(in coordinateSpace: CoordinateSpace = .global, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: geometry.frame(in: coordinateSpace))
            }
        )
        .onPreferenceChange(RectPreferenceKey.self, perform: onChange)
    }
    
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
