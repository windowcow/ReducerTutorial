import Foundation
import ComposableArchitecture

struct BoardChecker {
    static func checkWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        if let winner = checkRowWinner(board: board) {
            return winner
        }
        
        if let winner = checkColumnWinner(board: board) {
            return winner
        }
        
        if let winner = checkDiagonalWinner(board: board) {
            return winner
        }
        
        return nil
    }
    
    private static func checkRowWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        let size = Int(sqrt(Double(board.count)))
        for row in 0..<size {
            for col in 0..<(size-2) {
                if let cell0 = board.first(where: { $0.row == row && $0.col == col }),
                   let cell1 = board.first(where: { $0.row == row && $0.col == col + 1 }),
                   let cell2 = board.first(where: { $0.row == row && $0.col == col + 2 }),
                   let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                    return owner
                }
            }
        }
        return nil
    }
    
    private static func checkColumnWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        let size = Int(sqrt(Double(board.count)))
        for col in 0..<size {
            for row in 0..<(size-2) {
                if let cell0 = board.first(where: { $0.row == row && $0.col == col }),
                   let cell1 = board.first(where: { $0.row == row + 1 && $0.col == col }),
                   let cell2 = board.first(where: { $0.row == row + 2 && $0.col == col }),
                   let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                    return owner
                }
            }
        }
        return nil
    }
    
    private static func checkDiagonalWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        let size = Int(sqrt(Double(board.count)))
        // 우하향 대각선 체크
        for row in 0..<(size-2) {
            for col in 0..<(size-2) {
                if let cell0 = board.first(where: { $0.row == row && $0.col == col }),
                   let cell1 = board.first(where: { $0.row == row + 1 && $0.col == col + 1 }),
                   let cell2 = board.first(where: { $0.row == row + 2 && $0.col == col + 2 }),
                   let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                    return owner
                }
            }
        }
        
        // 우상향 대각선 체크
        for row in 2..<size {
            for col in 0..<(size-2) {
                if let cell0 = board.first(where: { $0.row == row && $0.col == col }),
                   let cell1 = board.first(where: { $0.row == row - 1 && $0.col == col + 1 }),
                   let cell2 = board.first(where: { $0.row == row - 2 && $0.col == col + 2 }),
                   let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                    return owner
                }
            }
        }
        
        return nil
    }
}
