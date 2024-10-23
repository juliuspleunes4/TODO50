//
//  ContentViewViewModel.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//
// https://firebase.google.com/docs/ios/setup firebase for database and registration
import Foundation
import FirebaseAuth

class ContentViewViewModel: ObservableObject {
    @Published var isSignedIn = false // published property to track the sign-in status
    @Published var currentUserId: String = "" // published property to track the sign-in status

    init() {
        checkUserStatus() // calls the function to check if he user is already signed in
    }

    func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            self.isSignedIn = true // if user is signed in, set isSignedIn to true
            self.currentUserId = user.uid // assign user's unique id to currentUserId
        } else {
            self.isSignedIn = false // if no user is signed in, set isSignedIn to false
            self.currentUserId = "" // reset the currentUserId to an empty string
        }

        // "listen" for future changes in auth status
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                DispatchQueue.main.async {
                    self?.isSignedIn = true // update isSignedIn to true when user is detected
                    self?.currentUserId = user.uid // assign user id when he is detected
                }
            } else {
                DispatchQueue.main.async {
                    self?.isSignedIn = false // update isSignedIn to false when no user is signed in
                    self?.currentUserId = "" // clear the currentUserId when no user is signed in
                }
            }
        }
    }
}
