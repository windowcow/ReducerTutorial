//
//  AppView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            Tab {
                ContentView(store: store.scope(state: \.tab1, action: \.tab1))
            } label: {
                Image(systemName: "house")
            }
            
            Tab {
                BoardView(
                    store: StoreOf<Board>(initialState: Board.State()) {
                        Board()
                    }
                )
                
                ContentView(store: store.scope(state: \.tab2, action: \.tab2))
            } label: {
                Image(systemName: "star")
            }
        }
    }
}

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        var tab1 = CounterFeature.State(count: 0)
        var tab2 = CounterFeature.State(count: 1)
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}
