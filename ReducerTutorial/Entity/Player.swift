//
//  Player.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/10/25.
//


import Foundation

enum Player: Identifiable {
    case o
    case x
    
    func nextPlayer() -> Player {
        switch self {
        case .o:
            return .x
        case .x:
            return .o
        }
    }
    
    var id: Self { self }
}

