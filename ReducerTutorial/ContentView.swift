//
//  ContentView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text(store.count.description)
            
            HStack {
                Button("Increment") {
                    self.store.send(.increaseButtonTapped)
                }
                
                Button("Decrement") {
                    self.store.send(.decreaseButtonTapped)
                }
            }
        }
        .padding()
    }
}

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count: Int
    }
    
    enum Action {
        case decreaseButtonTapped
        case increaseButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decreaseButtonTapped:
                state.count -= 1
                return .none
            case .increaseButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}


#Preview {
    ContentView(
        store: Store(
            initialState: CounterFeature.State(count: 1),
            reducer: {
                CounterFeature()
            }
        )
    )
}
