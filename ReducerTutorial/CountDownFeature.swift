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
struct CountDown {
    @ObservableState
    struct State {
        var countDown: TimeInterval
    }
    
    enum Action {
        case onAppear
        case startTimer
        case timerTicked
        case stopTimer
        case delegate(Delegate)
        
        enum Delegate {
            case timerFinished
        }
    }
    
    @Dependency(\.suspendingClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.startTimer)
                
            case .startTimer:
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CountDown.timerCancelID)
                
            case .timerTicked:
                if state.countDown > 0 {
                    state.countDown -= 1
                    return .none
                } else {
                    return .concatenate(.send(.stopTimer), .send(.delegate(.timerFinished)))
                }
            case .stopTimer:
                return .cancel(id: CountDown.timerCancelID)
                
            case .delegate:
                return .none
            }
        }
    }
    
    static let timerCancelID = "timerCancelID"
}

private struct CountDownView: View {
    let store: StoreOf<CountDown>
    
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
    CountDownView(
        store: Store(
            initialState: CountDown.State(countDown: 10),
            reducer: {CountDown()}
        )
    )
}
