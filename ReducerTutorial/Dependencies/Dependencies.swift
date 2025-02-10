//
//  Dependencies.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/10/25.
//

import ComposableArchitecture

// 현재 플레이어 정보를 저장하는 DependencyKey 정의
struct CurrentPlayerKey: DependencyKey {
    static let liveValue: Player = .o  // 기본값을 nil로 설정
}

// DependencyValues에 추가
extension DependencyValues {
    var currentPlayer: Player {
        get { self[CurrentPlayerKey.self] }
        set { self[CurrentPlayerKey.self] = newValue }
    }
}
