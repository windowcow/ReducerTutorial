//
//  GameState.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GameState {
    @ObservableState
    enum State {
        case playing
        case ended(EndReason)
    }
    
    @CasePathable
    enum EndReason {
        case draw
        case win(Player)
    }
    
    enum Action {
        case start
        case end(EndReason)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .start:
                state = .playing
                return .none
            case let .end(endReason):
                state = .ended(endReason)
                return .none
            }
        }
    }
}
