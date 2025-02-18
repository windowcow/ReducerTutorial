//
//  Score.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerScore {
    @ObservableState
    struct State {
        var p1Score: Int = 0
        var p2Score: Int = 0
    }
    
    enum Action {
        case p1Score
        case p2Score
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .p1Score:
                state.p1Score += 1
                return .none
            case .p2Score:
                state.p2Score += 1
                return .none
            }
        }
    }
}
