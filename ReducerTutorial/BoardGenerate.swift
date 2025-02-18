//
//  BoardGenerate.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import ComposableArchitecture

@Reducer
struct BoardSettings {
    @ObservableState
    struct State {
        var rowCount: Int
        var colCount: Int
    }
    
    enum Action {
        case incrementRowCount
        case decrementRowCount
        case incrementColCount
        case decrementColCount
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementRowCount:
                if state.rowCount < 8 {
                    state.rowCount += 1
                }
                return .none
            case .decrementRowCount:
                if state.rowCount > 3 {
                    state.rowCount -= 1
                }
                
                return .none
            case .incrementColCount:
                if state.colCount < 8 {
                    state.colCount += 1
                }
                return .none
            case .decrementColCount:
                if state.colCount > 3 {
                    state.colCount -= 1
                }
                return .none
            }
        }
    }
}
