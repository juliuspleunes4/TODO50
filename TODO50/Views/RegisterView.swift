//
//  RegisterView.swift
//  TODO50
//
//  Created by Julius Pleunes on 19/10/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegisterView: View {
    @State var fullname = "" // stores user fullname
    @State var emailaddress = "" // stores user email
    @State var userpassword = "" // stores user password
    @State var errorMessage: String? // displays errors
    @State var isLoading = false // if tasks are loading
    
    var body: some View {
        VStack {
            // header
            HeaderView(title: "Register here!",
                       subtitle: "Tick off your tasks, start today!",
                       angle: -15, // tilted the other way as the LoginView
                       background: .cyan) // cyan background for registration instead of red
            
            // registration form with similar styling as LoginView
            VStack(spacing: 20) {
                TextField("", text: $fullname) // text field for user fullname
                    .placeholder(when: fullname.isEmpty) {
                        Text("Enter your full name here...")
                            .foregroundColor(.gray) // placeholder color
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                
                TextField("", text: $emailaddress) // text field for user email
                    .placeholder(when: emailaddress.isEmpty) {
                        Text("Enter your email here...")
                            .foregroundColor(.gray) // placeholder color
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .autocapitalization(.none) // disables auto capitalisation
                    .autocorrectionDisabled(true) // disables auto correction
                    .foregroundColor(.black)
                
                SecureField("", text: $userpassword) // secure text field for password
                    .placeholder(when: userpassword.isEmpty) {
                        Text("Enter your password here...")
                            .foregroundColor(.gray) // placeholder color
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                
                if let errorMessage = errorMessage { // displays error message if present
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                Button {
                    registerUser() // calls the register function
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.green) // green for register
                        Text(isLoading ? "Loading..." : "Create an account!") // displays loading when isLoading is true
                            .foregroundColor(Color.white)
                            .bold()
                    }
                    .frame(height: 50)
                }
                .disabled(isLoading) // disable button when loading
                .padding(.top)
            }
            
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .background( // adds background image
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onTapGesture {
            hideKeyboard() // hide the keyboard when tapping outside text fields
        }
    }
    
    func registerUser() {
        // reset error message
        errorMessage = nil
        
        // validate input fields
        guard !fullname.isEmpty && !emailaddress.isEmpty && !userpassword.isEmpty else {
            errorMessage = "Please fill in all fields" // error message
            return
        }
        
        guard emailaddress.contains("@") && emailaddress.contains(".") else {
            errorMessage = "Please enter a valid email address" // error message
            return
        }
        
        isLoading = true // shows the loading state
        
        // register user with firebase
        Auth.auth().createUser(withEmail: emailaddress, password: userpassword) { authResult, error in
            isLoading = false // hides loading state
            
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = authResult?.user {
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "fullname": fullname,
                    "email": emailaddress
                ]) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        // go to TODOListView after successful registration
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: TODOListView())
                            window.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    
    // Hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
