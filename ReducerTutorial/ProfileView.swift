//
//  ProfileView.swift
//  TripleT
//
//  Created by windowcow on 2/5/25.
//


import SwiftUI

struct ProfileView: View {
    var userID: String?
    
    var body: some View {
        Text(userID ?? "No Opponent")
    }
}
