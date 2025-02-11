//
//  Cell.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//


import SwiftUI
import Combine
import ComposableArchitecture

@ViewAction(for: Cell.self)
struct CellView: View {
    let store: StoreOf<Cell>
    
    var body: some View {
        Circle()
            .foregroundStyle(.gray)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if store.owner == .o {
                    Text("O")
                } else if store.owner == .x {
                    Text("X")
                }
            }
            .onTapGesture {
                send(.tapped)
            }
    }
}

@Reducer
struct Cell {
    @ObservableState
    struct State {
        @Shared(.currentTurnPlayer) var currentTurnPlayer = .o

        let index: Int
        var owner: Player?
    }
    
    enum Action: Sendable, ViewAction {
        case view(View)
        case delegate(DelegateAction)
        case setOwner(Player)

        enum View: ViewAction {
            case tapped
        }
        
        @CasePathable
        enum DelegateAction {
            case occupiedEventHappened
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.tapped):
                let isAlreadyOccupied = state.owner != nil
                guard !isAlreadyOccupied else { return .none } // 이미 있는 경우에는 중단 (또는 alert animation)
                
                return .send(.setOwner(state.currentTurnPlayer)) // 주인이 없으면 주인 설정
                
            case .setOwner:
                state.owner = state.currentTurnPlayer
                return .send(.delegate(.occupiedEventHappened)) // 주인 설정 후에는 Board에 게임 결과 검증 시작
                
            case .delegate(.occupiedEventHappened):
                return .none
            }
        }
        ._printChanges()
    }
}

extension Cell.State: Identifiable {
    var id: Int { index }
}
