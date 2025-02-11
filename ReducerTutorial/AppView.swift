//
//  AppView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppReducer> = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    
    var body: some View {
        VStack {
            Spacer()
            BoardView(store: store.scope(state: \.board, action: \.board))
            Spacer()
        }
    }
}

// App 전체 상태 정의
@Reducer
struct AppReducer {
    struct State{
        var game = Game.State()
        var board = Board.State()
    }
    
    enum Action {
        case game(Game.Action)
        case board(Board.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.game, action: \.game) {
            Game()
        }
        
        Scope(state: \.board, action: \.board) {
            Board()
        }
        
    }
}
