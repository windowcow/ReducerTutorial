//
//  AppView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct GameFeature {
    struct State{
        var scoreFeature = ScoreFeature.State()
        var board = Board.State()
        @Shared(.currentTurnPlayer) var currentTurnPlayer = .o
    }
    
    enum Action {
        case scoreFeature(ScoreFeature.Action)
        case board(Board.Action)
        
        case changeCurrentTurnPlayer
        case clearScore
        case clearBoard
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.board, action: \.board) {
            Board()
        }
        
        Reduce { state, action in
            switch action {
            case .scoreFeature:
                return .none
            case let .board(.delegate(.transition(transitionType))):
                switch transitionType {
                case let .end(endReason):
                    switch endReason {
                    case let .win(winner):
                        return .send(.scoreFeature(.increaseScore(winner)))
                    case .draw:
                        return .none
                    }
                case .playing:
                    return .send(.clearBoard)
                }
            case .board:
                return .none
            case .changeCurrentTurnPlayer:
                return .none
            case .clearScore:
                return .send(.scoreFeature(.clearScores))
            case .clearBoard:
                return .send(.board(.clear))
            }
                
        }
        ._printChanges()
    }
}

struct AppView: View {
    let store: StoreOf<GameFeature> = Store(initialState: GameFeature.State()) {
        GameFeature()
    }
    
    var body: some View {
        VStack {
            Spacer()
            BoardView(store: store.scope(state: \.board, action: \.board))
            Spacer()
        }
    }
}
