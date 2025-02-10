//
//  ContentView.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    var body: some View {
        VStack {
            HStack {
                ProfileView(userID: "me")
                Spacer()
                ProfileView(userID: "friend")
            }
        }
    }
}

@Reducer
struct Game {
    @ObservableState
    struct State {
        var player1Score: Int = 0
        var player2Score: Int = 0
    }
    
    enum Action {
        case increasePlayer1Score
        case increasePlayer2Score
        case clearScores
        
        case resetBoard
        case resetCurrentPlayer
        
        case alert(AlertState<Alert>)
    }
}
