//
//  ScoreCard.swift
//  TicTacToe
//
//  Created by Nick on 10/15/23.
//

import ConfettiSwiftUI
import SwiftUI

struct ScoreCard: View {
    var player: String
    @Binding var score: Int
    var gameStarted: Bool
    var isComputer: Bool?
    var isTurn: Bool
    
    var body: some View {
            VStack {
                HStack {
                    Text("\(player)")
                        .font(.custom("Futura-Bold", size: 40))
                    if gameStarted {
                        Text("-")
                            .font(.custom("Futura-Bold", size: 24))
                        Text("\(score)")
                            .font(.custom("Futura-Bold", size: 24))
                    }
                }
                .animation(.easeIn, value: gameStarted)
                
                Text(isComputer ?? false ? "Computer" : " ")
                    .font(.custom("Futura", size: 18))
                    .foregroundColor(.gray)
                    .offset(y: -4)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(content: {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(isTurn ? .green : .white, lineWidth: 5)
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).fill(.white))
            })
            .cornerRadius(10)
            .shadow(color: Color(.sRGB, white: 0.85, opacity: 1), radius: 8)
            .confettiCannon(counter: $score, confettiSize: 18)
    }
}
