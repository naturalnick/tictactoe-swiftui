//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [String?] = Array(repeating: nil, count: 9)
    @Published var isTurnX = true
    @Published var winner: String?
    @Published var multiplayerModeOn = false
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0
    @Published var isResetButtonVisible = false
    @Published var showMultiPlayerMemo = false {
        didSet {
            if self.showMultiPlayerMemo == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self.showMultiPlayerMemo = false
                }
            }
        }
    }
    
    var scoreTotal: Int { xScore + oScore }
    
    var roundStarted: Bool {
        return xScore + oScore > 0
    }
    var gameStarted: Bool {
        moves.contains { $0 != nil }
    }
    
    func handlePlayerMove(moveIndex: Int) {
        if moves[moveIndex] != nil { return }
        
        if !multiplayerModeOn && !isTurnX { return }
        
        moves[moveIndex] = isTurnX ? "x" : "o"
        
        if checkForWin(in: moves) {
            winner = isTurnX ? "x" : "o"
            if isTurnX { xScore += 1 }
            else { oScore += 1 }
            return
        }
        
        if checkGridFilled(in: moves) {
            winner = ""
            return
        }
        
        isTurnX.toggle()
        if multiplayerModeOn { return }
        
        // handle computer move after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            let computerMove = determineComputerMove(in: moves)
            
            if (isTurnX) { return }
            
            moves[computerMove] = "o"
            
            if checkForWin(in: moves) {
                winner = "o"
                oScore += 1
                return
            }
            
            if checkGridFilled(in: moves) {
                winner = ""
                return
            }
            isTurnX.toggle()
        }
    }
    
    func resetGame() {
        if (!gameStarted && roundStarted) {
            xScore = 0
            oScore = 0
        }
        
        winner = nil
        moves = Array(repeating: nil, count: 9)
        isTurnX = true
    }
    
    func toggleMultiplayerMode() {
        multiplayerModeOn = !multiplayerModeOn
        showMultiPlayerMemo = true
        resetGame()
    }
    
    func determineComputerMove(in moves: [String?]) -> Int {
        var moveIndex = Int.random(in: 0..<8)
        
        let winPatterns: Set<Set<Int>> = [
                [0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal
                [0, 3, 6], [1, 4, 7], [2, 5, 8], // Vertical
                [0, 4, 8], [2, 4, 6]             // Diagonal
            ]
        
        let computerPositions = moves.indices.filter { moves[$0] == "o" }
        
        // computer will win if it has the chance
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = moves[winPositions.first!] == nil
                if isAvailable { return winPositions.first!}
            }
        }
        
        let humanPositions = moves.indices.filter { moves[$0] == "x" }
        
        // computer will block if you are set up to win
        for pattern in winPatterns {
            let blockPositions = pattern.subtracting(humanPositions)
            
            if blockPositions.count == 1 {
                let isAvailable = moves[blockPositions.first!] == nil
                if isAvailable { return blockPositions.first!}
            }
        }
        
        
        while moves[moveIndex] != nil {
            moveIndex = Int.random(in: 0..<8)
        }
        
        return moveIndex
    }
    
    func checkGridFilled(in moves: [String?]) -> Bool{
        return !moves.contains(where: {$0 == nil})
    }
    
    func checkForWin(in moves: [String?]) -> Bool {
        let winPatterns: [[Int]] = [
                [0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal
                [0, 3, 6], [1, 4, 7], [2, 5, 8], // Vertical
                [0, 4, 8], [2, 4, 6]             // Diagonal
            ]

            for pattern in winPatterns {
                let marks = pattern.map { moves[$0] }
                if marks == ["x", "x", "x"] || marks == ["o", "o", "o"] {
                    return true
                }
            }

            return false
    }
}
