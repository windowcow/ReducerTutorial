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
            
            if store.isLoading {
                ProgressView()
            }
            
            Text(store.fetchedTodo?.title ?? "")
            
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

let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count: Int
        var isLoading: Bool = false
        var fetchedTodo: Todo?
    }
    
    enum Action {
        case decreaseButtonTapped
        case increaseButtonTapped
        case evenCountEvent
        case todoResponse(Todo?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decreaseButtonTapped:
                state.count -= 1
                return .none
            case .increaseButtonTapped:
                state.count += 1
                
                if state.count.isMultiple(of: 2) {
                    return .send(.evenCountEvent)
                }
                
                return .none
            case .evenCountEvent:
                state.isLoading = true
                return .run { send in
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let todo = try! JSONDecoder().decode(Todo.self, from: data)
                    print(todo)
                    await send(.todoResponse(todo))
                }
            case .todoResponse(let todo):
                state.fetchedTodo = todo
                state.isLoading = false
                return .none
            }
        }
    }
}


#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
