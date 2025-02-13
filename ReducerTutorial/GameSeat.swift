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
        var oUser: LocalUser = LocalUser(nickname: "O", score: 0)
        var xUser: LocalUser = LocalUser(nickname: "X", score: 0)
    }
    
    enum Action {
        case swapUserSeat
        case clearScore
        case updateWinnerScore(Player)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .swapUserSeat:
                let newXUserNickName = state.oUser.nickname
                let newOUserNickNAme = state.xUser.nickname
                
                state.oUser.nickname = newOUserNickNAme
                state.xUser.nickname = newXUserNickName
                return .none
            case .clearScore:
                state.oUser.score = 0
                state.xUser.score = 0
                return .none
            case let .updateWinnerScore(winner):
                if winner == .o {
                    state.oUser.score += 1
                } else {
                    state.xUser.score += 1
                }
                return .none
            }
        }
        ._printChanges()
    }
}
