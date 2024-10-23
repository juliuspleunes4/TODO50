//
//  ProfileView.swift
//  TODO50
//
//  Created by Julius Pleunes on 22/10/2024.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userEmail = "" // stores user email so it can be displayed in profile page

    var body: some View {
        VStack(spacing: 20) {
            // profile header
            HStack {
                Image(systemName: "person.circle.fill") // user sf symbol
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text(userEmail) // displays user email
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, 40)

            // Log Out knop
            Button(action: {
                logOutUser() // calls log out function
            }) {
                Text("Log Out")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .onAppear(perform: fetchUserData) // fetches user data when the view appears
        .background(
            Image("background") // adds background image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    func fetchUserData() {
        if let user = Auth.auth().currentUser { // fetches the current user data
            userEmail = user.email ?? "No Email Available" // assigns the users email to userMail
        }
    }

    func logOutUser() {
        do {
            try Auth.auth().signOut() // signs user out
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: LoginView()) // redirects to login view after signing out
                window.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError) // logs an error if sign out fails
        }
    }
}
