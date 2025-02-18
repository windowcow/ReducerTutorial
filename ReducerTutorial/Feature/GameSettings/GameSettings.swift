//
//  GameSettings.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GameSettings {
    @ObservableState
    struct State {
        var maxScore: Int = 3
        var boardSettings = BoardSettings.State(rowCount: 3, colCount: 3)
        var playerSettings1 = PlayerSettings.State(name: "Player 1", color: .red)
        var playerSettings2 = PlayerSettings.State(name: "Player 2", color: .blue)
    }
    
    enum Action {
        case setMaxScore(Int)
        case boardSettings(BoardSettings.Action)
        case playerSettings1(PlayerSettings.Action)
        case playerSettings2(PlayerSettings.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.boardSettings, action: \.boardSettings) {
            BoardSettings()
        }
    }
}
