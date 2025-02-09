//
//  ReducerTutorialApp.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct ReducerTutorialApp: App {
    static let store = Store(initialState: CounterFeature.State(count: 1)) {
        CounterFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: ReducerTutorialApp.store)
        }
    }
}
