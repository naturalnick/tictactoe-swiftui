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
        return proxy.size.width / 3
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: spaceWidth,
                       height: spaceWidth)
                .foregroundColor(.clear)
            
            if spaceIndex < 6 {
                BorderLine(side: .bottom, areaWidth: spaceWidth)
            }
            if spaceIndex > 0 && spaceIndex % 3 != 0 {
                BorderLine(side: .leading, areaWidth: spaceWidth)
            }
            
            MoveIndicator(player: moves[spaceIndex], proxy: proxy)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            handlePlayerMove(spaceIndex)
        }
    }
}

struct MoveIndicator: View {
    var player: String?
    var proxy: GeometryProxy
    
    var body: some View {
        if let player = player {
            Text(player.uppercased())
                .font(.system(size: proxy.size.width/3/2 , weight: .black, design: .serif))
        }
    }
}

enum BorderSide {
    case top, bottom, leading, trailing
}

struct BorderPath {
    var startPoint: CGPoint
    var endPoint: CGPoint
}

struct BorderLine: View {
    var side: BorderSide
    var areaWidth: CGFloat
    
    var lineWidth: CGFloat = 5
    
    var borderPath: BorderPath {
        switch side {
        case .top:
            return BorderPath(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: areaWidth, y: 0))
        case .bottom:
            return BorderPath(startPoint: CGPoint(x: 0, y: areaWidth), endPoint: CGPoint(x: areaWidth, y: areaWidth))
        case .leading:
            return BorderPath(startPoint: CGPoint(x: -(lineWidth / 2) / 2, y: 0), endPoint: CGPoint(x: -(lineWidth / 2) / 2, y: areaWidth))
        case .trailing:
            return BorderPath(startPoint: CGPoint(x: areaWidth - lineWidth / 2, y: 0), endPoint: CGPoint(x: areaWidth - lineWidth / 2, y: areaWidth))
        }
    }
    
    var body: some View {
        Path() { path in
            path.move(to: borderPath.startPoint)
            path.addLine(to: borderPath.endPoint)
        }
        .stroke(.gray, lineWidth: lineWidth)
    }
}
