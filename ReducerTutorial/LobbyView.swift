//
//  ContentView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LobbyView {
    @ObservableState
    struct State {
        let title: String = "Tic Tac Toe"
        var boardSettings = BoardSettings.State()
        @PresentationState var game: Game.State?
    }
}
        
        
