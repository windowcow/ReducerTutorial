//
//  Board.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//


import SwiftUI
import ComposableArchitecture

struct BoardView: View {
    let store: StoreOf<Board>
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(store.scope(state: \.cells, action: \.cells)) { store in
                CellView(store: store)
            }
        }
    }
}

@Reducer
struct Board {
    @Dependency(\.currentPlayer) var currentPlayer
    
    @ObservableState
    struct State {
        @Shared(.currentTurnPlayer) var currentTurnPlayer = .o
        var cells: IdentifiedArrayOf<Cell.State> = .init(uniqueElements: (0..<9).map { i in Cell.State(index: i) })
    }
    
    enum Action: Sendable {
        case cells(IdentifiedActionOf<Cell>)
        case checkWinner
        case nextTurn
        case delegate(GameAction) // GameFeature에 로 점수 업데이트를 시킨다.
        
        enum GameAction {
            case updateWinnerScore(Player)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cells(.element(id: _, action: .delegate(.occupiedEventHappened))):
                return .send(.checkWinner)

            case .checkWinner:
                if let winner = self.winner(state) {
                    return .send(.delegate(.updateWinnerScore(winner)))
                } else {
                    return .send(.nextTurn)
                }
                
            case .nextTurn:
                state.$currentTurnPlayer.withLock { currentTurnPlayer in
                    currentTurnPlayer = currentTurnPlayer.nextPlayer()
                }
                
                return .none
                
            case .delegate: return .none
            default: return .none
                
            }
            
        }
        .forEach(\.cells, action: \.cells) {
            Cell()
        }
        ._printChanges()
    }
}

extension Board {
    private func hasWin(_ state: State, player: Player) -> Bool {
        let winConditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [6, 4, 2],
        ]

        for condition in winConditions {
            let matches = condition.map { state.cells[$0].owner }
            if matches.allSatisfy({ $0 == player }) {
                return true
            }
        }
        return false
    }

    private func winner(_ state: State) -> Player? {
        if hasWin(state, player: .x) {
            return .x
        } else if hasWin(state, player: .o) {
            return .o
        } else {
            return nil
        }
    }
}
