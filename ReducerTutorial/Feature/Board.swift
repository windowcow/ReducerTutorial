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
        var cells: IdentifiedArrayOf<Cell.State> = InitialCellsBuilder.build()
        
        init(row: Int, col: Int) {
            self.cells = InitialCellsBuilder.build(rows: row, cols: col)
        }
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
    private func occupiedCellCount(for state: State) -> Int {
        return state.cells.filter { $0.owner != nil }.count
    }
    
    private func checkWinner(board: IdentifiedArrayOf<Cell.State>) -> Player? {
        return BoardChecker.checkWinner(board: board)
    }
}
