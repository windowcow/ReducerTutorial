//
//  ProfileView.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//


import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: StoreOf<UserFeature>
    
    var body: some View {
        Text(store.score.description)
    }
}

@Reducer
struct UserFeature {
    @ObservableState
    struct State {
        var score: Int = 0
    }
    
    enum Action { }
}
