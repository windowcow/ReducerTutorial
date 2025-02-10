//
//  Todo.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import Foundation

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
