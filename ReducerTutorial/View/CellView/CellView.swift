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
        RoundedRectangle(cornerRadius: 30)
            .foregroundStyle(.gray)
            .border(Color.black, width: 3)
            .overlay {
                if store.owner == .o {
                    Text("O")
                } else if store.owner == .x {
                    Text("X")
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
                send(.tapped)
            }
    }
}

@Reducer
struct Cell {
    @ObservableState
    struct State {
        // MARK: SHARED
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
        
        enum DelegateAction {
            case validateMove
        }
    }
    /**
    전략:
     탭 -> 보드에 검증 -> 보드가 setOwner 시키거나, 무효시키거나, 승리 시킨다.
     
     */
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.tapped):
                return .run { send in await send(.delegate(.validateMove)) }
            
            case .delegate(.validateMove):
                // 사실상 이 경우는 실행이 되지 않는 경우이다.
                return .none
                
            case .setOwner:
                state.owner = state.currentTurnPlayer
                
                return .none
            }
        }
    }
}

extension Cell.State: Identifiable {
    var id: Int { index }
}


// Board(Delegate)에게 처리 방법을 물어본다.
// 자기가 멋대로 놓아버린다면 문제가 생긴다 -> 그건 아니다 setOwner에 Delegate로 계산 요청하면 된다.
// 문제는. Cell은 현재 누구 차례인지를 모른다는거다. -> Shared로 해결
