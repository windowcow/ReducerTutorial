//
//  SharedReaderKey+.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/10/25.
//

import ComposableArchitecture

extension SharedReaderKey where Self == InMemoryKey<Player> {
  static var currentTurnPlayer: Self {
      inMemory("currentTurnPlayer")
  }
}

extension SharedReaderKey where Self == InMemoryKey<Int> {
    static var player1Score: Self {
        inMemory("player1Score")
    }
    
    static var player2Score: Self {
        inMemory("player2Score")
    }
}
