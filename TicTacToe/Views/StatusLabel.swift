//
//  StatusLabel.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

struct StatusLabel: View {
    
    var winner: String?
    var isTurnX: Bool
    
    var statusText: String {
        guard let winner = winner else {
            
            return isTurnX ? "X's Turn" : "O's Turn"
        }
        
        return winner == "" ? "Draw!" : "\(winner.uppercased()) Wins!"
    }
    
    var body: some View {
        Text(statusText)
            .font(.system(size: 60, weight: .black, design: .serif))
    }
}

struct StatusLabel_Previews: PreviewProvider {
    static var previews: some View {
        StatusLabel(isTurnX: true)
        StatusLabel(winner: "o", isTurnX: true)
    }
}
