//
//  User.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/10/25.
//


import Foundation

struct User: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    
    static var user1: User { .init(name: "User 1") }
    static var user2: User { .init(name: "User 2") }
}
