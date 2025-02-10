//
//  Board.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//


import SwiftUI
import ComposableArchitecture

struct BoardView: View {
    let store: StoreOf<Board>
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(store.scope(state: \.cells, action: \.cells)) { store in
                CellView(store: store)
            }
        }
    }
}

@Reducer
struct Board {
    @Dependency(\.currentPlayer) var currentPlayer
    
    @ObservableState
    struct State {
        var cells: IdentifiedArrayOf<Cell.State> = .init(uniqueElements: (0..<9).map { i in Cell.State(index: i) })
    }
    
    enum Action: Sendable {
        case cells(IdentifiedActionOf<Cell>)
//        case check
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cells(.element(id: _, action: .delegate(let delegateAction))) :
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.cells, action: \.cells) {
            Cell()
        }
    }
}

