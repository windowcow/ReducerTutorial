//
//  PlayerInfoView.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

struct PlayerInfoView<T: User>: View {
    @Shared(.currentTurnPlayer) var currentTurnPlayer: Player = .o
    var user: T

    // 플레이어별 색상을 결정 (여기서는 "O"이면 파란색, 나머지는 빨간색으로 가정)
    private var playerColor: Color {
        user.nickname == "O" ? .blue : .red
    }
    
    // 현재 뷰에 표시된 플레이어가 현재 턴인지 판단
    private var isCurrentTurn: Bool {
        // 예시로 "O" 플레이어면 currentTurnPlayer가 .o여야 함.
        // 만약 다른 플레이어라면 currentTurnPlayer가 .o가 아닐 것으로 가정.
        return (user.nickname == "O" && currentTurnPlayer == .o) ||
               (user.nickname != "O" && currentTurnPlayer != .o)
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("PLAYER")
                    .font(.caption)
                Text("\(user.nickname)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(playerColor)
            }
            Spacer()
            Text("\(user.score)")
                .contentTransition(.numericText())
                .animation(.spring, value: user.score)
                .font(.system(size: 75))
                .bold()
            Spacer()
        }
        .padding()
        // 현재 턴이면 플레이어 고유 색상의 테두리를, 아니면 테두리 없음
        .background(
            Capsule()
                .foregroundStyle(isCurrentTurn ? playerColor.opacity(0.3) : Color.clear)
        )
    }
}

#Preview {
    PlayerInfoView(user: LocalUser(nickname: "O", score: 3))
}
