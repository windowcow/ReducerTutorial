//
//  CountDownFeature.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct CountDownFeature {
    @ObservableState
    struct State {
        var countDown: TimeInterval
    }
    
    enum Action {
        case onAppear
        case timerTicked
        case timerFinished
    }
    
    @Dependency(\.suspendingClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CountDownFeature.timerCancelID)
                
            case .timerTicked:
                state.countDown -= 1
                if state.countDown <= 0 {
                    return .concatenate(.cancel(id: CountDownFeature.timerCancelID), .send(.timerFinished))
                }
                return .none
                
            case .timerFinished:
                return .none
            }
        }
    }
    
    static let timerCancelID = "timerCancelID"
}

struct CountDownFeatureView: View {
    let store: StoreOf<CountDownFeature>
    
    var body: some View {
        VStack {
            Text("Countdown: \(store.countDown)")
                .font(.largeTitle)
                .padding()
            
            Button("Start Timer") {
                store.send(.onAppear)
            }
            .padding()
        }
        .task {
            store.send(.onAppear)
        }
    }
}

#Preview {
    CountDownFeatureView(
        store: Store(
            initialState: CountDownFeature.State(countDown: 10),
            reducer: {CountDownFeature()}
        )
    )
}
