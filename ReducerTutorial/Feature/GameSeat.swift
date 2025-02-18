//
//  GameSeat.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//

import ComposableArchitecture


@Reducer
struct GameSeat {
    @ObservableState
    struct State {
        var player1 = Player.o
        var player2 = Player.x
    }
    
    enum Action {
        case swapUserSeat
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .swapUserSeat:
                let temp = state.player1
                state.player1 = state.player2
                state.player2 = temp
                return .none
            }
        }
    }
}
