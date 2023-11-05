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
    var player: String?
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .playerMove)
    }
}

extension UTType {
    static let playerMove = UTType(exportedAs: "com.nickschaefer.playerMove")
}

struct GameSpace: View {
    var spaceIndex: Int
    var screenWidth: CGFloat
    var handlePlayerMove: (Int) -> Void
    var handleDrag: (Int, Int) -> Void
    var moves: [String?]
    
    var spaceWidth: CGFloat {
        return (screenWidth - 20) / 3
    }
    
    @State var isTargeted = false
    
    var body: some View {
        ZStack {
            Button {
                handlePlayerMove(spaceIndex)
            } label: {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .padding(.all, 5)
                    .foregroundColor(isTargeted ? .white.opacity(0.6) : .white)
                    .shadow(color: Color(.sRGB, white: 0.85, opacity: 1), radius: 8)
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(moves[spaceIndex] != nil)
            
            MoveIndicator(playerMove: PlayerMove(index: spaceIndex, player: moves[spaceIndex]), spaceWidth: spaceWidth)
        }
        .frame(width: spaceWidth,
               height: spaceWidth)
        .dropDestination(for: PlayerMove.self) { items, location in
            let dropIndex = items[0].index
            
            if moves[spaceIndex] != nil || dropIndex == spaceIndex { return false }
            
            handleDrag(dropIndex, spaceIndex)
            
            return true
        } isTargeted: { isTargeted in
            self.isTargeted = isTargeted
        }
    }
}

struct MoveIndicator: View {
    var playerMove: PlayerMove
    var spaceWidth: CGFloat
    
    var body: some View {
        if let player = playerMove.player {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: spaceWidth/1.6))
                .padding(.horizontal)
                .animation(.easeIn, value: player)
                .draggable(playerMove) {
                    Text(player.uppercased())
                        .font(.custom("Futura-Bold", size: spaceWidth/1.6))
                        .padding(.horizontal)
                }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
