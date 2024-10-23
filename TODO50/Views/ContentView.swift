//
//  ContentView.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel() // observes changes in ContentViewViewModel

    var body: some View {
        Group {
            if viewModel.isSignedIn {
                // show the to-do list view when the user is signed in
                TODOListView()
            } else {
                // show the login view when the user is not signed in
                LoginView()
            }
        }
    }
}
