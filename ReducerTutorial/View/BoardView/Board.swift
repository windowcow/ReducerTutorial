//
//  Board2.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/11/25.
//

import ComposableArchitecture

@Reducer
struct Board {
    @ObservableState
    struct State {
        var cells: IdentifiedArrayOf<CellFeature.State> = Board.initialCells()
        var currentPlayer: Player = .o
    }

    enum Action {
        case cells(IdentifiedActionOf<CellFeature>)
        case evaluate
        case newGame
        case clear
        case gameEnd(GameEnd)
        case nextTurn
        
        @CasePathable
        enum GameEnd {
            case hasWinner(Player)
            case draw
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cells(.element(id: _, action: .alreadyTaken)):
                return .none
            case .cells(.element(id: _, action: .setOwner)):
                return .send(.evaluate)
            case .cells:
                return .none
                
            case .evaluate:
                if let winner = checkWinner(board: state.cells) {
                    return .send(.gameEnd(.hasWinner(winner)))
                }
                
                if occupiedCellCount(for: state) == 9 {
                    return .send(.gameEnd(.draw))
                }
                
                return .send(.nextTurn)
                
            case .nextTurn:
                state.currentPlayer = state.currentPlayer.nextPlayer()
                return .none
                
            case .newGame:
                return .send(.clear)
                
            case .gameEnd:
                return .none
                
            case .clear:
                state = .init()
                return .none
            }
        }
        .forEach(\.cells, action: \.cells) {
            CellFeature()
        }
        ._printChanges()
    }
    
}

extension Board: Equatable {}

extension Board {
    private static func initialCells() -> IdentifiedArrayOf<CellFeature.State> {
        var array = IdentifiedArrayOf<CellFeature.State>()
        
        for row in 0..<3 {
            for col in 0..<3 {
                let cellState = CellFeature.State(row: row, col: col)
                array.append(cellState)
            }
        }
        
        return array
    }

    private func occupiedCellCount(for state: State) -> Int {
        return state.cells.filter { $0.owner != nil }.count
    }
    
    private func checkWinner(board: IdentifiedArrayOf<CellFeature.State>) -> Player? {
        for row in 0..<3 {
            if let cell0 = board.first(where: { $0.row == row && $0.col == 0 }),
               let cell1 = board.first(where: { $0.row == row && $0.col == 1 }),
               let cell2 = board.first(where: { $0.row == row && $0.col == 2 }),
               let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                return owner
            }
        }
        
        for col in 0..<3 {
            if let cell0 = board.first(where: { $0.row == 0 && $0.col == col }),
               let cell1 = board.first(where: { $0.row == 1 && $0.col == col }),
               let cell2 = board.first(where: { $0.row == 2 && $0.col == col }),
               let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
                return owner
            }
        }
        
        if let cell0 = board.first(where: { $0.row == 0 && $0.col == 0 }),
           let cell1 = board.first(where: { $0.row == 1 && $0.col == 1 }),
           let cell2 = board.first(where: { $0.row == 2 && $0.col == 2 }),
           let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
            return owner
        }
        
        if let cell0 = board.first(where: { $0.row == 0 && $0.col == 2 }),
           let cell1 = board.first(where: { $0.row == 1 && $0.col == 1 }),
           let cell2 = board.first(where: { $0.row == 2 && $0.col == 0 }),
           let owner = cell0.owner, owner == cell1.owner, owner == cell2.owner {
            return owner
        }
        
        return nil
    }
}
