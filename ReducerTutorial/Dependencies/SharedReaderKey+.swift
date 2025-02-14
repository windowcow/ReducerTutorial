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
