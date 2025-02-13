//
//  Board2View.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/11/25.
//

import SwiftUI
import ComposableArchitecture

struct BoardView: View {
    @State private var shakeAmount: CGFloat = 0
    let store: StoreOf<Board>
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(store.scope(state: \.cells, action: \.cells), id: \.id) { cellFeatureStore in
                CellView(store: cellFeatureStore)
            }
        }
        .padding(8)
    }
}
