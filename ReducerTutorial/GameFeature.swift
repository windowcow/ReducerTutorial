//
//  AppView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Game {
    @ObservableState
    struct State{
        var board: Board.State
        var gameSeat = GameSeat.State()
        var timer = 
    }
    
    enum Action {
        case board(Board.Action)
        case gameSeat(GameSeat.Action)
        
        case changeCurrentTurnPlayer
        case updateWinnerScore(Player)
        case clearScore
        case clearBoard
        
        case showAlert(Board.StateType.EndReason)
        case alert(PresentationAction<Alert>)
        
        enum Alert {
            case confirmGameResult
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.board, action: \.board) {
            Board()
        }
        
        Scope(state: \.gameSeat, action: \.gameSeat) {
            GameSeat()
        }
        
        Reduce { state, action in
            switch action {
            case let .board(.delegate(.transition(transitionType))):
                switch transitionType {
                case let .end(endReason):
                    return .run { send in
                        switch endReason {
                        case let .win(winner):
                            await send(.updateWinnerScore(winner))
                        case .draw:
                            break
                        }
                        
                        await send(.showAlert(endReason))
                    }
                case .playing:
                    return .send(.clearBoard)
                }
            case .board:
                return .none
            case .gameSeat:
                return .none
            case let .showAlert(endReason):
                switch endReason {
                case .draw:
                    state.alert = AlertState {
                        TextState("Draw")
                    } actions: {
                        ButtonState(action: .confirmGameResult) {
                            TextState("Confirm")
                        }
                    }
                case let .win(winner):
                    state.alert = AlertState {
                        TextState("\(winner == .x ? "X" : "O") Wins!")
                    } actions: {
                        ButtonState(action: .confirmGameResult) {
                            TextState("Confirm")
                        }
                    }
                }
                
                return .none
            case .alert(.presented(.confirmGameResult)):
                return .run { send in
                    await send(.gameSeat(.swapUserSeat))
                    await send(.clearBoard)
                }
            case .alert:
                return .none
            case let .updateWinnerScore(winner):
                return .run {send in 
                    await send(.gameSeat(.updateWinnerScore(winner)))
                }
            case .changeCurrentTurnPlayer:
                return .none
            case .clearScore:
                return .none
            case .clearBoard:
                return .send(.board(.clear))
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<GameFeature> = Store(initialState: GameFeature.State()) {
        GameFeature()
    }
    
    var body: some View {
        VStack {
            PlayerInfoView(user: store.gameSeat.xUser)
                .rotationEffect(.init(degrees: 180), anchor: .center)
            Spacer()
            BoardView(store: store.scope(state: \.board, action: \.board))
            Spacer()
            PlayerInfoView(user: store.gameSeat.oUser)
        }
        .padding()
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}


