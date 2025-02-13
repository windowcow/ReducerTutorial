//
//  CellFeature.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct CellFeature {
    @ObservableState
    struct State {
        let row: Int
        let col: Int
        @Shared(.currentTurnPlayer) var currentTurnPlayer: Player = .o
        var owner: Player?
        var animationState = AnimationState()
        
        struct AnimationState {
            var toggle = false
            var offset: CGFloat = 0
        }
    }
    
    enum Action {
        case tapped
        case setOwner(Player)
        case alreadyTaken
        case animation(Animation)
        
        @CasePathable
        enum Animation {
            case shakes
        }
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                if let owner = state.owner {
                    return .send(.alreadyTaken)
                } else {
                    return .send(.setOwner(state.currentTurnPlayer))
                }
            case let .setOwner(currentTurnPlayer):
                state.owner = currentTurnPlayer
                return .none
            case .alreadyTaken:
                return .send(.animation(.shakes), animation: .linear)
            case .animation(.shakes):
                return .none
            }
        }
        ._printChanges()
    }
}

extension CellFeature.State: Identifiable {
    var id: Int {
        row * 10 + col
    }
}

struct CellView: View {
    let store: StoreOf<CellFeature>
    
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
            .sensoryFeedback(.error, trigger: store.animationState.toggle)
    }
}

struct OccupiedCellView: View {
    var player: Player
    
    var body: some View {
        Text("\(player == .o ? "O" : "X")")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.blue)
    }
}

#Preview {
    CellView(
        store: Store(initialState: CellFeature.State(row: 0, col: 0)) {
            CellFeature()
        }
    )
}
