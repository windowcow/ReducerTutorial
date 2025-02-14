//
//  User.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/13/25.
//

import ComposableArchitecture

protocol User {
    var nickname: String { get }
    var score: Int { get }
}

struct LocalUser: User {
    var nickname: String
    var score: Int
}
