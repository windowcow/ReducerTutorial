//
//  BoardGenerate.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BoardSettings {
    @ObservableState
    struct State: Equatable {
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


private struct BoardSettingsView: View {
    let store: StoreOf<BoardSettings>
    
    var body: some View {
        VStack {
            HStack {
                Text("Rows: \(store.rowCount)")
                Button("-") { store.send(.decrementRowCount) }
                Button("+") { store.send(.incrementRowCount) }
            }
            HStack {
                Text("Columns: \(store.colCount)")
                Button("-") { store.send(.decrementColCount) }
                Button("+") { store.send(.incrementColCount) }
            }
        }
    }
}

#Preview {
    BoardSettingsView(
        store: Store(
            initialState: BoardSettings.State(rowCount: 3, colCount: 3)
        ) {
            BoardSettings()
        }
    )
}
