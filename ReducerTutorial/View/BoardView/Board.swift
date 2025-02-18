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
        var cells: IdentifiedArrayOf<Cell.State> = Board.initialCells()
    }
    
    enum Action {
        case cells(IdentifiedActionOf<Cell>)
        case evaluate
        case clear
        
        case delegate(Delegate)
        
        enum Delegate {
            case hasWinner(Player)
            case draw
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cells(.element(id: _, action: .setOwner)):
                return .send(.evaluate)
            case .cells:
                return .none
            case .evaluate:
                if let winner = BoardChecker.checkWinner(board: state.cells) {
                    return .send(.delegate(.hasWinner(winner)))
                }
                if occupiedCellCount(for: state) == 9 {
                    return .send(.delegate(.draw))
                }
                return .none
                
            case .clear:
                state = .init()
                return .none
            case .delegate:
                return .none
            }
        }
        .forEach(\.cells, action: \.cells) {
            Cell()
        }
    }
    
}

extension Board: Equatable {}

extension Board {
    private static func initialCells() -> IdentifiedArrayOf<Cell.State> {
        var array = IdentifiedArrayOf<Cell.State>()
        
        for row in 0..<3 {
            for col in 0..<3 {
                let cellState = Cell.State(row: row, col: col)
                array.append(cellState)
            }
        }
        
        return array
    }

    private func occupiedCellCount(for state: State) -> Int {
        return state.cells.filter { $0.owner != nil }.count
    }
    
    private func checkWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        return BoardChecker.checkWinner(board: board)
    }
}
