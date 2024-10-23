//
//  TODO50App.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//

// https://firebase.google.com/docs/ios/setup firebase for database and registration
// SF Symbols were used in my app: https://developer.apple.com/sf-symbols/
import FirebaseCore
import SwiftUI
import FirebaseAuth

@main
struct TODO50App: App {
    
    init() { // initialises firebase
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //ChatGPT was used for the command:
                .preferredColorScheme(.light) // forces app to stay in light mode
                //prompt: "in Xcode: how to force app to stay in light mode?"
                //ChatGPT recommended adding this command in the AppDelegate file. Since I don't have that file because I don't need that file, I moved it to this file
        }
    }
}
