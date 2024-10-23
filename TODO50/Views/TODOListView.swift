//
//  TODOListView.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct TODOListView: View {
    @State private var todos: [(task: String, isChecked: Bool)] = [] // stores the user's todo list and checked status
    @State private var newTodo = ""
    @State private var showingNewItemView = false // tracks if NewItemsView is presented
    @State private var showingProfileView = false // tracks if ProfileView is presented
    @State private var isLoading = true // tracks the loading state
    @State private var errorMessage: String? // stores error messages
    @State private var retryCount = 0 // retry counter
    
    private let db = Firestore.firestore()
    private var user = Auth.auth().currentUser // get the current loggedin user
    
    var body: some View {
        ZStack {
            // main content view
            VStack {
                // title and plus button
                HStack {
                    Text("TODO50")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        // show new screen with animation
                        showingNewItemView.toggle()
                    }) {
                        Image(systemName: "plus.app")
                            .font(.title)
                            .padding(.trailing)
                    }
                }
                .padding(.top, 10)
                
                // divider line
                Divider()
                    .padding(.horizontal)
                
                // loading status or error displayed
                if isLoading {
                    ProgressView("Loading tasks...")
                        .padding(.top, 50)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 50)
                    Button("Retry") {
                        retryFetchTodos() // retry on failure
                    }
                } else {
                    List {
                        ForEach(todos.indices, id: \.self) { index in
                            HStack {
                                Text(todos[index].task)
                                    .foregroundColor(.black)
                                    .padding()
                                    .font(.system(size: 18, weight: .medium))
                                
                                Spacer()
                                
                                Button(action: {
                                    // toggle checked status
                                    todos[index].isChecked.toggle()
                                    updateTodoCheckedStatus(index: index)
                                }) {
                                    Image(systemName: todos[index].isChecked ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onDelete(perform: deleteTodo) // adds swipe to delete
                    }
                    .listStyle(PlainListStyle()) // deletes standard style
                    .background(Color.clear) // 
                }
                
                Spacer()
                
                // navigation buttons
                HStack {
                    // left button = main screen
                    Button(action: {
                    }) {
                        VStack {
                            Image(systemName: "rectangle.inset.filled.and.person.filled")
                            Text("Main")
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // right button = profile
                    Button(action: {
                        showingProfileView.toggle() // show profile page
                    }) {
                        VStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 10)
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            // sheet style to add new tasks
            .sheet(isPresented: $showingNewItemView) {
                NewItemsView(isPresented: $showingNewItemView, onSave: addNewTodo)
                    .background( // adds the background image
                        Image("background")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    )
            }
            // sheet for profile view
            .sheet(isPresented: $showingProfileView) {
                ProfileView()
            }
        }
        .onAppear(perform: fetchTodos) // fetches todos when the view appears
    }
    
    // function to add new task to firebase database
    func addNewTodo(_ task: String) {
        guard !task.isEmpty, let uid = user?.uid else { return }
        
        // creates new todo document for the current user
        let todo = ["task": task, "isChecked": false] as [String : Any]
        
        db.collection("users").document(uid).collection("todos").addDocument(data: todo) { error in
            if let error = error {
                print("Error adding todo: \(error.localizedDescription)")
            } else {
                self.todos.append((task: task, isChecked: false))
            }
        }
    }
    
    // function to fetch tasks
    func fetchTodos() {
        guard let uid = user?.uid else { return }
        isLoading = true
        errorMessage = nil
        retryCount = 0 // reset retry counter
        
        // timeout set to 10 seconds of loading
        let timeoutSeconds = 10.0
        var fetchCompleted = false
        
        db.collection("users").document(uid).collection("todos")
            .getDocuments { snapshot, error in
                isLoading = false
                fetchCompleted = true
                
                if let error = error {
                    errorMessage = "Error loading tasks: \(error.localizedDescription)"
                } else {
                    let fetchedTodos = snapshot?.documents.compactMap { doc -> (String, Bool)? in
                        guard let task = doc["task"] as? String, let isChecked = doc["isChecked"] as? Bool else { return nil }
                        return (task, isChecked)
                    } ?? []
                    self.todos = fetchedTodos
                    if todos.isEmpty {
                        errorMessage = "No tasks available."
                    }
                }
            }
        
        // if fetching takes too long, show error message
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSeconds) {
            if !fetchCompleted {
                isLoading = false
                errorMessage = "Failed to load tasks (timeout)."
            }
        }
    }
    
    // retry mechanism
    func retryFetchTodos() {
        if retryCount < 3 {
            retryCount += 1
            isLoading = true
            fetchTodos() // retry fetching todos
        } else {
            errorMessage = "Failed to load tasks after multiple attempts."
        }
    }
    
    // updates checked status from task in firebase
    func updateTodoCheckedStatus(index: Int) {
        guard let uid = user?.uid else { return }
        let taskToUpdate = todos[index]
        
        db.collection("users").document(uid).collection("todos")
            .whereField("task", isEqualTo: taskToUpdate.task)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error updating todo: \(error.localizedDescription)")
                } else if let document = snapshot?.documents.first {
                    document.reference.updateData(["isChecked": taskToUpdate.isChecked]) { error in
                        if let error = error {
                            print("Error updating todo: \(error.localizedDescription)")
                        }
                    }
                }
            }
    }
    
    // function to delete task from list and firebase
    func deleteTodo(at offsets: IndexSet) {
        guard let uid = user?.uid else { return }
        let index = offsets.first!
        let todoToDelete = todos[index]
        
        // fetches document to delete from firebase
        db.collection("users").document(uid).collection("todos")
            .whereField("task", isEqualTo: todoToDelete.task)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error deleting todo: \(error.localizedDescription)")
                } else if let document = snapshot?.documents.first {
                    document.reference.delete() { error in
                        if let error = error {
                            print("Error deleting todo: \(error.localizedDescription)")
                        } else {
                            self.todos.remove(at: index) // remove task from local list
                        }
                    }
                }
            }
    }
}
