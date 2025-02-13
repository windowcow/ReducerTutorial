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
    @ObservableState
    struct State{
        @Shared(.currentTurnPlayer) var currentTurnPlayer = .o
        @Presents var alert: AlertState<Action.Alert>?
        
        var scoreFeature = ScoreFeature.State()
        var board = Board.State()
    }
    
    enum Action {
        case scoreFeature(ScoreFeature.Action)
        case board(Board.Action)
        
        case changeCurrentTurnPlayer
        case clearScore
        case clearBoard
        
        case showAlert
        case alert(PresentationAction<Alert>)
        
        enum Alert {
            case confirmGameResult
        }
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
                    return .run { send in
                        switch endReason {
                        case let .win(winner):
                            await send(.scoreFeature(.increaseScore(winner)))
                        case .draw:
                            break
                        }
                        
                        await send(.showAlert)
                    }
                case .playing:
                    return .send(.clearBoard)
                }
            case .showAlert:
                state.alert = AlertState {
                    TextState("OK?")
                } actions: {
                    ButtonState(action: .confirmGameResult) {
                        TextState("OK")
                    }
                }
                return .none
            case .alert(.presented(.confirmGameResult)):
                return .send(.clearBoard)
            case .alert:
                return .none
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
        .ifLet(\.$alert, action: \.alert)
        ._printChanges()
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<GameFeature> = Store(initialState: GameFeature.State()) {
        GameFeature()
    }
    
    var body: some View {
        VStack {
            Spacer()
            BoardView(store: store.scope(state: \.board, action: \.board))
            Spacer()
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
