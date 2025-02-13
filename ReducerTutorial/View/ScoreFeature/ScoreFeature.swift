////
////  ContentView.swift
////  TripleT
////
////  Created by windowcow on 2/5/25.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//
//@Reducer
//struct ScoreFeature {
//    @ObservableState
//    struct State {
//        var player1Score: Int = 0
//        var player2Score: Int = 0
//    }
//    
//    enum Action {
//        case increaseScore(Player)
//        case clearScores
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .increaseScore(player):
//                if player == .o {
//                    state.player1Score += 1
//                } else if player == .x {
//                    state.player2Score += 1
//                }
//                return .none
//            case .clearScores:
//                state.player1Score = 0
//                state.player2Score = 0
//                return .none
//            }
//        }
//        ._printChanges()
//    }
//}
//
//
