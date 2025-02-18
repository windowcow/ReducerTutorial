//
//  CellFeature.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct Cell {
    @ObservableState
    struct State {
        let row: Int
        let col: Int
        @Shared(.currentTurnPlayer) var currentTurnPlayer: Player = .o
        var owner: Player?
    }
    
    enum Action {
        case tapped
        case alreadyTaken
        case setOwner(Player)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                let action: Action = state.owner == nil ?
                    .setOwner(state.currentTurnPlayer) :
                    .alreadyTaken
                return .send(action)
            case .alreadyTaken:
                return .none
            case let .setOwner(currentTurnPlayer):
                state.owner = currentTurnPlayer
                return .none
            }
        }
    }
}

extension Cell.State: Identifiable {
    var id: Int {
        [row, col].hashValue
    }
}

struct CellView: View {
    let store: StoreOf<Cell>
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.white)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if let owner = store.owner {
                    OccupiedCellView(player: owner)
                }
            }
            .onTapGesture {
                store.send(.tapped)
            }
            .sensoryFeedback(.error, trigger: store.owner)
    }
}

#Preview {
    CellView(
        store: Store(initialState: Cell.State(row: 0, col: 0)) {
            Cell()
        }
    )
}
