//
//  LoginView.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State var emailaddress = "" // stores userinput (email)
    @State var userpassword = "" // stores userinput (password)
    @State var errorMessage: String? // for displaying error messages
    @State var isLoading = false // for showing a loading state
    
    var body: some View {
        NavigationView {
            VStack {
                // header
                HeaderView(title: "TODO50",
                           subtitle: "Tick off your tasks!",
                           angle: 15,
                           background: .red) // reusable header component
                
                // login form with white background and rounded corners
                VStack(spacing: 20) {
                    TextField("Enter email here...", text: $emailaddress) // text field for email input
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .foregroundColor(.black)
                    
                    SecureField("Enter password here...", text: $userpassword) // text field for password
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .foregroundColor(.black)
                    
                    if let errorMessage = errorMessage { // shows error if there is one
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }
                    
                    Button {
                        loginUser() // calls login function
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.red)
                            Text(isLoading ? "Loading..." : "Log In") // shows 'Loading...' when isLoading is true
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
                
                VStack {
                    Text("Hey there! New here?")
                        .foregroundColor(.black)
                    
                    NavigationLink("Create an account!", destination: RegisterView()) // link to registration page
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .background( // sets background image to the background.png file
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            // ChatGPT was used for the TapGesture function
            // prompt used: "How do I implement the ability to hide the keyboard when user presses somewhere on the screen in Xcode?"
            // ChatGPT recommended the use of this feature
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    // login function
    func loginUser() {
        errorMessage = nil // resets error
        isLoading = true // displays loading
        
        // validates input field
        guard !emailaddress.isEmpty && !userpassword.isEmpty else {
            errorMessage = "Please fill in all fields" // shows error if fields are empty
            isLoading = false
            return
        }
        
        guard emailaddress.contains("@") && emailaddress.contains(".") else {
            errorMessage = "Please enter a valid email address" // shows error if email is not valid
            isLoading = false
            return
        }
        
        // Inloggen via Firebase
        Auth.auth().signIn(withEmail: emailaddress, password: userpassword) { authResult, error in
            isLoading = false
            
            if let error = error {
                // logs error and displays
                print("Error during login: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            } else if let user = authResult?.user {
                print("User logged in: \(user.email ?? "No Email")") // log de users email
                // redirects to TODOListView after successful login
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: TODOListView())
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    // https://developer.apple.com/documentation/uikit/uiresponder
    // function to hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// custom placeholder modifier for TextFields
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView() 
    }
}
