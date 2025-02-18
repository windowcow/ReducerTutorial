//
//  PlayerSettings.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/18/25.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct PlayerSettings {
    @ObservableState
    struct State {
        var name: String = "player"
        var photo: UIImage = UIImage(systemName: "person.crop.circle") ?? UIImage()
        var color: UIColor
        var countDown: Int = 30
    }
    
    enum Action {
        case setPhoto(UIImage)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setPhoto(photo):
                state.photo = photo
                return .none
            }
        }
    }
}
