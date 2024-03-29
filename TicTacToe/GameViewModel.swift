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
    
    @Published var availableNumbers = (1...9).map { String($0) }
    
    @Published var chooseIndex: Int?
    
    @Published var dragOriginIndex: Int?
    
    @Published var selectedGameType: GameType = GameType.classic {
        didSet { resetGame() }
    }
    
    @Published var isResetButtonVisible = false
    
    let winPatterns: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Vertical
        [0, 4, 8], [2, 4, 6]             // Diagonal
    ]
    
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
            print((isTurnX, moves[dragOriginIndex] == "x", xPieceCount == 0))
            if (isTurnX && moves[dragOriginIndex] == "x" && xPieceCount == 0) || (!isTurnX && moves[dragOriginIndex] == "o" && oPieceCount == 0) {
                if selectedGameType == .threeMensMorris {
                    
                    let validMoves = selectedGameType.validMoves![dragOriginIndex]
                    
                    return validMoves.filter { availablePositions.contains($0) }
                } else if selectedGameType == .nineHoles {
                    return availablePositions
                }
            }
        }
        return []
    }
    
    func handlePlayerMove(moveIndex: Int, piece: String? = nil) {
        if moves[moveIndex] != nil { return }
        
        if !multiplayerModeOn && !isTurnX { return }
        
        switch selectedGameType {
        case .threeMensMorris, .nineHoles:
            if isTurnX && xPieceCount > 0 {
                xPieceCount -= 1
                moves[moveIndex] = "x"
            } else if !isTurnX && oPieceCount > 0 {
                oPieceCount -= 1
                moves[moveIndex] = "o"
            } else { return }
        case .wild:
            moves[moveIndex] = piece!
        case .numerical:
            moves[moveIndex] = piece!
            availableNumbers = availableNumbers.filter { $0 != piece }
        default:
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
            
            switch selectedGameType {
            case .threeMensMorris, .nineHoles:
                if oPieceCount > 0 {
                    oPieceCount -= 1
                    moves[computerMove.toIndex] = "o"
                } else if let fromIndex = computerMove.fromIndex {
                    moves[fromIndex] = nil
                    moves[computerMove.toIndex] = "o"
                }
            case .wild:
                moves[computerMove.toIndex] = ["x", "o"].randomElement()
            case .numerical:
                let computerNumber = availableNumbers.randomElement()
                moves[computerMove.toIndex] = computerNumber
                availableNumbers = availableNumbers.filter { $0 != computerNumber }
            default:
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
        
        chooseIndex = nil
        
        availableNumbers = (1...9).map { String($0) }
        
        winner = nil
        moves = Array(repeating: nil, count: 9)
        isTurnX = true
    }
    
    func toggleMultiplayerMode() {
        multiplayerModeOn = !multiplayerModeOn
        resetGame()
    }
    
    func determineComputerMove(in moves: [String?], with gameType: GameType) -> Move {
        let computerPositions = moves.indices.filter { moves[$0] == "o" }
        
        if gameType.threePieceLimit && oPieceCount == 0 {
            var fromIndex = computerPositions.randomElement()
            var toIndex: Int? = availablePositions.randomElement()!
            
            if gameType == .threeMensMorris {
                toIndex = nil
                while (toIndex == nil) {
                    let validMovesFromIndex = gameType.validMoves![fromIndex!]
                    let availableValidMoves = availablePositions.filter { validMovesFromIndex.contains($0) }
                    
                    if availableValidMoves.count > 0 {
                        toIndex = availableValidMoves.randomElement()!
                    }
                        
                    fromIndex = computerPositions.randomElement()
                }
            }
            
            return Move(fromIndex: fromIndex, toIndex: toIndex!)
        }

        let winPositions = getWinPositions(currentPositions: computerPositions)
            
        if gameType == .reverse {
            let reversePositions = getReversePositions(winPositions: winPositions)
            return Move(toIndex: reversePositions.randomElement()!)
        }
        
        if winPositions.count > 0 { return Move(toIndex: winPositions.randomElement()!) }
        
        let blockPositions = getBlockPositions(moves: moves)
        if blockPositions.count > 0 { return Move(toIndex: blockPositions.randomElement()!) }
        
        let randomMoveIndex = availablePositions.randomElement()!
        return Move(toIndex: randomMoveIndex)
    }
    
    func getWinPositions(currentPositions: [Int]) -> [Int] {
        var winPositions: [Int] = []
        for pattern in winPatterns {
            let positions = pattern.filter { !currentPositions.contains($0) }
            
            if positions.count == 1 && availablePositions.contains(positions.first!) {
                 winPositions.append(positions.first!)
            }
        }
        return winPositions
    }
    
    func getBlockPositions(moves: [String?]) -> [Int] {
        let humanPositions = moves.indices.filter { moves[$0] == "x" }
        var blockPositions: [Int] = []
        for pattern in winPatterns {
            let positions = pattern.filter { !humanPositions.contains($0) }
            
            if positions.count == 1 && availablePositions.contains(positions.first!) {
                blockPositions.append(positions.first!)
            }
        }
        return blockPositions
    }
    
    func getReversePositions(winPositions: [Int]) -> [Int] {
        var reversePositions: [Int] = []
        for num in 0...8 {
            if !winPositions.contains(num) && availablePositions.contains(num) {
                reversePositions.append(num)
            }
        }
        return reversePositions
    }
    
    func checkForDraw(in moves: [String?]) -> Bool {
        return !moves.contains(where: { $0 == nil })
    }
    
    func findWinner(in moves: [String?], with gameType: GameType) -> String? {
        switch selectedGameType {
        case .numerical:
            for pattern in winPatterns {
                let numbers = pattern.compactMap { moves[$0].flatMap { Int($0) } }
                if numbers.count == 3 && numbers.reduce(0, +) == 15 {
                    return isTurnX ? "x" : "o"
                }
            }
        default:
            for pattern in winPatterns {
                let marks = pattern.map { moves[$0] }
                if marks == ["x", "x", "x"] {
                    return gameType == .reverse ? "o" : "x"
                } else if marks == ["o", "o", "o"] {
                    return gameType == .reverse ? "x" : "o"
                }
            }
        }
        return nil
    }
}
