//
//  NewItemsView.swift
//  TODO50
//
//  Created by Julius Pleunes on 18/10/2024.
//

import SwiftUI

struct NewItemsView: View {
    @Binding var isPresented: Bool // to close this view
    @State private var newTask = "" // stores userinput for new task
    
    var onSave: (String) -> Void // to save new task
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                // header for new item screen
                HStack {
                    Text("New Task")
                        .foregroundColor(.white) // text color
                        .font(.headline)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false // exit screen
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white) // X button to close
                            .padding()
                    }
                }
                .background(Color.red) // header same color as button (red)
                
                // textfield with placeholder
                TextField("", text: $newTask)
                    .placeholder(when: newTask.isEmpty) {
                        Text("Enter your new task...").foregroundColor(.gray) // gray color for good readability
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                Button(action: {
                    // add new task and close screen
                    if !newTask.isEmpty {
                        onSave(newTask) // saves task to list
                        isPresented = false // close screen after adding
                    }
                }) {
                    Text("Add Task")
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red) // red colored button
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .background(
                Image("background") // adds background image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .cornerRadius(20)
            .padding()
            .frame(height: UIScreen.main.bounds.height / 2)
        }
    }
}

