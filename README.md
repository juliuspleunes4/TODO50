# TODO50

#### Video Demo: https://youtu.be/wCN-_jE_ODQ

#### Description:

TODO50 is a to-do list app built in Swift that helps users manage their tasks easily. It uses Firebase for user authentication and to store the tasks. The app allows users to add new tasks, check them off when completed, and delete them once done. All of this data is stored in the cloud, so users can access their tasks from any device as long as they are logged in.

With Firebase, users can securely log in and keep track of their to-do lists. This ensures that tasks are never lost and are always synced. Users need to sign up and log in to view and manage their personal to-do list. The app remembers the logged-in user and takes them to the login screen if they log out.

The app’s interface is clean and simple, with clear buttons and tasks that are easy to manage. Users can add tasks by clicking the plus button, delete tasks by swiping left, and mark tasks as done by checking them off.

Main files in this project (not every file):

TODO50App.swift:
This is the main entry file that launches the app. It checks if the user is already logged in. If the user is logged in, it shows the task list; otherwise, it displays the login screen. Firebase is also initialized here.
LoginView.swift:
This screen allows users to log in. It includes fields to enter an email address and password. Once the form is correctly filled out, the app authenticates the user via Firebase. If there’s an error (like a wrong password), the user is shown an error message.
RegisterView.swift:
This screen allows new users to sign up. Users can enter their full name, email, and password. Once the account is created, this information is stored securely in Firebase, and the user is directed to the task list screen.
TODOListView.swift:
This is the main screen of the app where the user’s tasks are displayed. Users can add new tasks by clicking the plus button, check off tasks when completed, and swipe left to delete tasks. All data is synced with Firebase Firestore, so the task list remains up to date even if the app is closed.
ProfileView.swift:
This screen displays the user’s email and provides an option to log out. When the user logs out, they are returned to the login screen. The profile is simple but allows users to manage their account.
NewItemsView.swift:
This screen appears when the user wants to add a new task. After entering a task, it is saved in Firestore, and the user is taken back to the task list with their new task added.


Design Choices:

When creating TODO50, I made several key design decisions to keep the app simple yet effective.

Firebase for User Management and Task Storage:
I chose Firebase because it offers a secure and easy way to manage user accounts and store data (in this case, the tasks) in the cloud. This means users can view and update their tasks from any device as long as they are logged in. Firebase also makes it easy to sync tasks in real-time and ensures that user data is stored securely. You can read more about Firebase here: https://firebase.google.com
SF Symbols for Icons:
I used Apple’s SF Symbols for all the icons in the app. These are standard symbols provided by Apple, and they ensure the app looks consistent and works well across all screen sizes. You can learn more about SF Symbols here: https://developer.apple.com/sf-symbols/
User-Friendly Task Management:
The app is designed to make task management easy. With just one click, users can add or remove tasks. Checking off tasks is done with a simple checkmark icon, and swiping allows users to quickly delete tasks. This ensures users can manage their to-do lists quickly and efficiently.
Error Messages and User Feedback:
When signing up or logging in, users might run into issues like incorrect passwords or invalid emails. The app provides clear error messages to guide the user on what went wrong. This helps keep the experience smooth and informative.



Final Thoughts:

TODO50 is a simple, yet powerful to-do list app that uses modern technology like Firebase and SwiftUI. It gives users a convenient way to manage their daily tasks, no matter where they are. With features like registration, login, and cloud-based task management, this app offers a complete solution for keeping track of tasks.

The design is kept clean, with clear buttons and an easy-to-navigate interface. Using Firebase for storing data ensures that the user experience is smooth, even when switching between different devices.

You can view the code on GitHub via this link: https://github.com/juliuspleunes4/TODO50/tree/main
