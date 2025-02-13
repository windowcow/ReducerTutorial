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
    
    var body: some View {
        Grid {
            ForEach(0..<3, id: \.self) { row in
                GridRow {
                    ForEach(0..<3, id: \.self) { col in
                        Circle()
                            .foregroundStyle(.gray)
                            .aspectRatio(1, contentMode: .fit)
                            
                            .overlay {
                                let owner = store.cells[row][col]
                                
                                if owner == .filled(.o) {
                                    Text("O")
                                } else if owner == .filled(.x) {
                                    Text("X")
                                }
                            }
                            .onTapGesture {
                                store.send(.view(.tap(row, col)))
                            }
                            .sensoryFeedback(.error, trigger: store.showOccupiedAlert) { $1 == true }
                    }
                }
            }
        }
    }
}
