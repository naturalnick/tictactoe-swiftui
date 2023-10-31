//
//  GameSpace.swift
//  TicTacToe
//
//  Created by Nick on 10/1/23.
//

import SwiftUI

struct GameSpace: View {
    var spaceIndex: Int
    var proxy: GeometryProxy
    var handlePlayerMove: (Int) -> Void
    var moves: [String?]
    
    var spaceWidth: CGFloat {
        return (proxy.size.width - 20) / 3
    }
    
    var body: some View {
        ZStack {
            Button {
                handlePlayerMove(spaceIndex)
            } label: {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .padding(.all, 5)
                    .foregroundColor(.white)
                    .shadow(color: Color(.sRGB, white: 0.85, opacity: 1), radius: 8)
            }
                .buttonStyle(ScaleButtonStyle())
            
            MoveIndicator(player: moves[spaceIndex], proxy: proxy)
        }
        .frame(width: spaceWidth,
               height: spaceWidth)
    }
}

struct MoveIndicator: View {
    var player: String?
    var proxy: GeometryProxy
    
    var body: some View {
        if let player {
            Text(player.uppercased())
                .font(.custom("Futura-Bold", size: proxy.size.width/3/2))
                .animation(.easeIn, value: player)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
