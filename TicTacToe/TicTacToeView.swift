//
//  ContentView.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

struct TicTacToeView: View {
    @StateObject private var viewModel = TicTacToeViewModel()
 
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Spacer()
                    
                    StatusLabel(winner: viewModel.winner, isHumanTurn: viewModel.isHumanTurn)
                    
                    Spacer()
                    
                    GameGridView(columns: viewModel.columns, moves: viewModel.moves, handlePlayerMove: viewModel.handlePlayerMove, winner: viewModel.winner, proxy: geometry)
                    
                    Spacer()
                }
                .padding()
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Title()
                    ResetButton(resetGame: viewModel.resetGame)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacToeView()
    }
}

struct GameSpaceView: View {
    var spaceIndex: Int
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .frame(width: proxy.size.width/3 - 5,
                   height: proxy.size.width/3 - 5)
            .foregroundColor(.white)
            .padding(.bottom, spaceIndex < 6 ? 5.0 : 0)
            .background(spaceIndex < 6 ? .gray : .clear)
            .padding(.leading, 5.0)
            .background(spaceIndex > 0 && spaceIndex % 3 != 0 ? .gray : .clear)
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

struct GameGridView: View {
    var columns: [GridItem]
    var moves: [String?]
    var handlePlayerMove: (Int) -> Void
    var winner: String?
    var proxy: GeometryProxy
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<9) { i in
                ZStack {
                    GameSpaceView(spaceIndex: i, proxy: proxy)
                    
                    MoveIndicator(player: moves[i], proxy: proxy)
                }
                .onTapGesture {
                    handlePlayerMove(i)
                }
            }
            
        }
        .disabled(winner != nil)
    }
}

struct Title: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("XOXO")
                .font(.system(size: 40, weight: .black, design: .serif))
        }
    }
}

struct ResetButton: ToolbarContent {
    var resetGame: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: resetGame) {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .labelStyle(.iconOnly)
            .controlSize(.large)
            .foregroundColor(.gray)
            .font(.system(size: 24, weight: .black))
            .padding()
        }
    }
}
