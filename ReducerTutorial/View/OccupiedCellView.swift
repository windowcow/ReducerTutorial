//
//  OccupiedCellView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//


import SwiftUI
import ComposableArchitecture

struct OccupiedCellView: View {
    var player: Player
    
    var body: some View {
        Text("\(player == .o ? "O" : "X")")
            .font(.system(size: 50))
            .bold()
            .foregroundStyle(player == .o ? Color.blue : Color.red)
    }
}
