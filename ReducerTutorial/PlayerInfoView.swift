//
//  PlayerInfoView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//


import SwiftUI
import ComposableArchitecture

struct PlayerInfoView<T: User>: View {
    var user: T
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("PLAYER")
                    .font(.caption)
                Text("\(user.nickname)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(user.nickname == "O" ? .blue : .red)
                
            }
            Spacer()
            Text("\(user.score)")
                .font(.system(size: 75))
                .bold()
            Spacer()
        }
    }
}

#Preview {
    PlayerInfoView(user: LocalUser(nickname: "O", score: 3))
}
