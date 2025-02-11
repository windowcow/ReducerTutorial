//
//  ContentView.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct Game {
    @ObservableState
    struct State {
        var player1Score: Int = 0
        var player2Score: Int = 0
    }
    
    enum Action {
        case increasePlayer1Score
        case increasePlayer2Score
        case clearScores
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increasePlayer1Score:
                state.player1Score += 1
                return .none
            case .increasePlayer2Score:
                state.player2Score += 1
                return .none
            case .clearScores:
                state.player1Score = 0
                state.player2Score = 0
                return .none
            }
        }
        ._printChanges()
    }
}


