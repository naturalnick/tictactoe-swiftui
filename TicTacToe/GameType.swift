//
//  GameType.swift
//  TicTacToe
//
//  Created by Nick on 11/5/23.
//

enum GameType: String, CaseIterable, Identifiable {
    case classic, reverse, threeMensMorris, nineHoles, wild, numerical
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .classic:
            return "Tic Tac Toe"
        case .reverse:
            return "Reverse Tic Tac Toe"
        case .threeMensMorris:
            return "Three Men's Morris"
        case .nineHoles:
            return "Nine Holes"
        case .wild:
            return "Wild"
        case .numerical:
            return "Numerical"
        }
    }
    
    var moveable: Bool {
        switch self {
        case .classic, .reverse, .wild, .numerical:
            return false
        case .threeMensMorris, .nineHoles:
            return true
        }
    }
    
    var threePieceLimit: Bool {
        switch self {
        case .classic, .reverse, .wild, .numerical:
            return false
        case .threeMensMorris, .nineHoles:
            return true
        }
    }
    
    var validMoves: [[Int]]? {
        switch self {
        case .threeMensMorris:
            let adjacentNumbers: [[Int]] = [
                [1, 3, 4],
                [0, 2, 3, 4, 5],
                [1, 4, 5],
                [0, 1, 4, 6, 7],
                [0, 1, 2, 3, 5, 6, 7, 8],
                [1, 2, 4, 7, 8],
                [3, 4, 7],
                [3, 4, 5, 6, 8],
                [4, 5, 7]
            ]
            return adjacentNumbers
        default:
            return nil
        }
    }
    
    var rules: String {
        switch self {
        case .classic:
            return "Get 3 in a row to win!"
        case .reverse:
            return "Avoid 3 in a row!"
        case .threeMensMorris:
            return "Each player has 3 pieces. \n Pieces can be moved to adjacent free spaces once all pieces are down. \n Get 3 in a row to win!"
        case .nineHoles:
            return "Each player has 3 pieces. \n Pieces can be moved to free \n spaces once all pieces are down. \n Get 3 in a row to win! \n Diagonals do not count."
        case .wild:
            return "Play either piece. \n Get 3 in a row of any piece to win!"
        case .numerical:
            return "Play numbers 1 - 9. \n Get 3 in a row with sum of 15 to win!"
        }
    }
}

