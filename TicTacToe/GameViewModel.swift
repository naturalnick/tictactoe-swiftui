//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Nick on 9/30/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var moves: [String?] = Array(repeating: nil, count: 9)
    @Published var spaceRects: [CGRect?] = Array(repeating: nil, count: 9)
    
    @Published var isTurnX = true
    @Published var winner: String?
    @Published var multiplayerModeOn = false
    
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0
    
    @Published var xPieceCount: Int = 3
    @Published var oPieceCount: Int = 3
    
    @Published var isDragging = false
    @Published var dragOriginIndex: Int?
    
    @Published var selectedGameType: GameType = GameType.classic {
        didSet { if gameStarted { resetGame() } }
    }
    
    @Published var isResetButtonVisible = false
    
    var scoreTotal: Int { xScore + oScore }
    
    var roundStarted: Bool { xScore + oScore > 0 }
    var gameStarted: Bool {
        moves.contains { $0 != nil }
    }
    
    var availablePositions: [Int] {
        moves.enumerated().compactMap { $0.element == nil ? $0.offset : nil }
    }
    
    var validDragMoves: [Int] {
        if let dragOriginIndex {
            if (isTurnX && moves[dragOriginIndex] == "x" && xPieceCount == 0) || (!isTurnX && moves[dragOriginIndex] == "o" && oPieceCount == 0) {
                
                let validMoves = selectedGameType.validMoves![dragOriginIndex]
                
                return validMoves.filter { availablePositions.contains($0) }
            }
        }
        return []
    }
    
    func handlePlayerMove(moveIndex: Int) {
        if moves[moveIndex] != nil { return }
        
        if !multiplayerModeOn && !isTurnX { return }
        
        if selectedGameType.threePieceLimit {
            if isTurnX && xPieceCount > 0 {
                xPieceCount -= 1
                moves[moveIndex] = "x"
            } else if !isTurnX && oPieceCount > 0 {
                oPieceCount -= 1
                moves[moveIndex] = "o"
            } else { return }
        } else {
            moves[moveIndex] = isTurnX ? "x" : "o"
        }
        
        if checkForGameOver() { return }
        
        isTurnX.toggle()
        
        if !multiplayerModeOn {  handleComputerMove() }
    }
    
    struct Move {
        var fromIndex: Int?
        var toIndex: Int
    }
    
    func handleComputerMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            let computerMove = determineComputerMove(in: moves, with: selectedGameType)
            
            if (isTurnX) { return }
            
            if selectedGameType.threePieceLimit {
                if oPieceCount > 0 {
                    oPieceCount -= 1
                    moves[computerMove.toIndex] = "o"
                } else if let fromIndex = computerMove.fromIndex {
                    moves[fromIndex] = nil
                    moves[computerMove.toIndex] = "o"
                }
            } else {
                moves[computerMove.toIndex] = "o"
            }
            
            if checkForGameOver() { return }
            
            isTurnX.toggle()
        }
    }
    
    func dragValid(from fromIndex: Int, to toIndex: Int) -> Bool {
        return fromIndex != toIndex && validDragMoves.contains(toIndex)
    }
    
    func handleDrag(from fromIndex: Int, to toIndex: Int) -> Void {
        if selectedGameType.moveable && moves[toIndex] == nil {
            if isTurnX && moves[fromIndex] != "x" { return }
            if !isTurnX && moves[fromIndex] != "o" { return }
            
            if selectedGameType == .threeMensMorris && !selectedGameType.validMoves![fromIndex].contains(toIndex) { return }
            
            let player = moves[fromIndex]
            moves[fromIndex] = nil
            moves[toIndex] = player
            
            if checkForGameOver() { return }
            
            isTurnX.toggle()
            
            if !multiplayerModeOn {  handleComputerMove() }
        }
    }
    
    func checkForGameOver() -> Bool {
        if let newWinner = findWinner(in: moves, with: selectedGameType) {
            winner = newWinner
            if winner == "x" { xScore += 1 }
            else if winner == "o" { oScore += 1 }
            return true
        }
        
        if checkForDraw(in: moves) {
            winner = ""
            return true
        }
        
        return false
    }
    
    func resetGame() {
        if (!gameStarted && roundStarted) {
            xScore = 0
            oScore = 0
        }
        
        xPieceCount = 3
        oPieceCount = 3
        
        winner = nil
        moves = Array(repeating: nil, count: 9)
        isTurnX = true
    }
    
    func toggleMultiplayerMode() {
        multiplayerModeOn = !multiplayerModeOn
        resetGame()
    }
    
    func determineComputerMove(in moves: [String?], with gameType: GameType) -> Move {
        var completingMoves: [Int] = []
        
        let computerPositions = moves.indices.filter { moves[$0] == "o" }
        
        if gameType.threePieceLimit && oPieceCount == 0 {
            let fromIndex = computerPositions.randomElement()
            let toIndex = availablePositions.randomElement()!
            
            return Move(fromIndex: fromIndex, toIndex: toIndex)
        }
        
        // computer will win if it has the chance
        for pattern in gameType.winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                if availablePositions.contains(winPositions.first!) && gameType != .reverse { return Move(toIndex: winPositions.first!) }
                
                if gameType == .reverse {
                    completingMoves.append(winPositions.first!)
                }
            }
        }
        
        if gameType != .reverse {
            let humanPositions = moves.indices.filter { moves[$0] == "x" }
            
            // computer will block if you are set up to win
            for pattern in gameType.winPatterns {
                let blockPositions = pattern.subtracting(humanPositions)
                
                if blockPositions.count == 1 {
                    if availablePositions.contains(blockPositions.first!) && gameType != .reverse { return Move(toIndex: blockPositions.first!) }
                }
            }
        }
        
        var moveIndex = availablePositions.randomElement()!
        
        if gameType != .reverse { return Move(toIndex: moveIndex) }
        
        var remainingPositions: [Int] = availablePositions
        while remainingPositions.count > 1 {
            if completingMoves.contains(moveIndex) {
                remainingPositions.removeAll { $0 == moveIndex }
                moveIndex = remainingPositions.randomElement()!
            } else { return Move(toIndex: moveIndex) }
        }
        
        return Move(toIndex: moveIndex)
    }
    
    func checkForDraw(in moves: [String?]) -> Bool {
        return !moves.contains(where: { $0 == nil })
    }
    
    func findWinner(in moves: [String?], with gameType: GameType) -> String? {
        for pattern in gameType.winPatterns {
            let marks = pattern.map { moves[$0] }
            if marks == ["x", "x", "x"] {
                return gameType == .reverse ? "o" : "x"
            } else if marks == ["o", "o", "o"] {
                return gameType == .reverse ? "x" : "o"
            }
        }
        return nil
    }
}
