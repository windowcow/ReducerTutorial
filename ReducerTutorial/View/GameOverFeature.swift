//
//  GameOverFeature.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/10/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct GameOverFeature {
  @ObservableState
  struct State: Equatable {
    let winner: Player
  }
  
  enum Action: Sendable {
    case restartButtonTapped
    case delegate(Delegate)
      
    enum Delegate: Sendable {
      case restartGame
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .restartButtonTapped:
          return .merge(
            .run { _ in await self.dismiss() },
            .send(.delegate(.restartGame))
          )

      case .delegate:
        return .none
      }
    }
  }
}

// 간단한 GameOverView 예시 (원하는 대로 UI를 구성하세요)
struct GameOverView: View {
  let store: StoreOf<GameOverFeature>
  
  var body: some View {
      VStack(spacing: 16) {
        Text("게임 종료!")
          .font(.title)
          Text("승자: \(store.state.winner)")
          .font(.headline)
          
        Button("재시작") {
          store.send(.restartButtonTapped)
        }
      }
      .padding()
  }
}
