//
//  ContentView.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            HStack {
                ProfileView(userID: "me")
                Spacer()
                ProfileView(userID: "friend")
            }
            
//            BoardView()
//                .padding()
        }
    }
}
