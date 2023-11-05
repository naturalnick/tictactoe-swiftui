//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var moves: [String?] = Array(repeating: nil, count: 9)
    @Published var isTurnX = true
    @Published var winner: String?
    @Published var multiplayerModeOn = false
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0
    @Published var isResetButtonVisible = false
    @Published var selectedGameType: GameType = GameType.classic
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
        
        if let newWinner = findWinner(in: moves, with: selectedGameType) {
            winner = newWinner
            if winner == "x" { xScore += 1 }
            else if winner == "o" { oScore += 1 }
            return
        }
        
        if checkForDraw(in: moves) {
            winner = ""
            return
        }
        
        isTurnX.toggle()
        
        if !multiplayerModeOn {  handleComputerMove() }
    }
    
    func handleComputerMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            let computerMove = determineComputerMove(in: moves, with: selectedGameType)
            
            if (isTurnX) { return }
            
            moves[computerMove] = "o"
            
            if let newWinner = findWinner(in: moves, with: selectedGameType) {
                winner = newWinner
                if winner == "x" { xScore += 1 }
                else if winner == "o" { oScore += 1 }
                return
            }
            
            if checkForDraw(in: moves) {
                winner = ""
                return
            }
            
            isTurnX.toggle()
        }
    }
    
    func handleDrag(from fromIndex: Int, to toIndex: Int) {
        let player = moves[fromIndex]
        moves[fromIndex] = nil
        moves[toIndex] = player
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
    
    func determineComputerMove(in moves: [String?], with gameType: GameType) -> Int {
        var completingMoves: [Int] = []
        
        let computerPositions = moves.indices.filter { moves[$0] == "o" }
        
        var availablePositions = moves.enumerated().compactMap { $0.element == nil ? $0.offset : nil }
        
        // computer will win if it has the chance
        for pattern in gameType.winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                if availablePositions.contains(winPositions.first!) && gameType != GameType.reverse { return winPositions.first!}
                
                if gameType == GameType.reverse {
                    completingMoves.append(winPositions.first!)
                }
            }
        }
        
        if gameType != GameType.reverse {
            let humanPositions = moves.indices.filter { moves[$0] == "x" }
            
            // computer will block if you are set up to win
            for pattern in gameType.winPatterns {
                let blockPositions = pattern.subtracting(humanPositions)
                
                if blockPositions.count == 1 {
                    if availablePositions.contains(blockPositions.first!) && gameType != GameType.reverse { return blockPositions.first!}
                }
            }
        }
        
        var moveIndex = availablePositions.randomElement()!
        
        if gameType != GameType.reverse { return moveIndex }
        
        while availablePositions.count > 1 {
            if completingMoves.contains(moveIndex) {
                availablePositions.removeAll { $0 == moveIndex }
                moveIndex = availablePositions.randomElement()!
            } else { return moveIndex }
        }
        
        return moveIndex
    }
    
    func checkForDraw(in moves: [String?]) -> Bool {
        return !moves.contains(where: { $0 == nil })
    }
    
    func findWinner(in moves: [String?], with gameType: GameType) -> String? {
        for pattern in gameType.winPatterns {
            let marks = pattern.map { moves[$0] }
            if marks == ["x", "x", "x"] {
                return gameType == GameType.reverse ? "o" : "x"
            } else if marks == ["o", "o", "o"] {
                return gameType == GameType.reverse ? "x" : "o"
            }
        }
        return nil
    }
}
