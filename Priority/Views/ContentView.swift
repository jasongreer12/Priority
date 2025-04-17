//
//  ContentView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI
import Auth0

struct ContentView: View {
    @StateObject var taskViewModel = TaskViewModel()
    @State private var isLeftSideMenuOpen = false
    @State private var isRightSideMenuOpen = false
    @State private var showAddTaskSheet = false
    @State private var isProfileMenuOpen = false
    @State private var showCalendarSheet = false
    @State var user: User?
    
    var body: some View {
        Group {
            if false {
                VStack(spacing: 20) {
                    Text("Welcome to Priority!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Please log in to continue.")
                        .foregroundColor(.secondary)
                    Button("Login") {
                        self.login()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            } else {
                ZStack {
                    HomeView()
                        .environmentObject(taskViewModel)
                        .environment(\.managedObjectContext, TaskManager.shared.viewContext)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: { withAnimation { isLeftSideMenuOpen.toggle() } }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button(action: { showAddTaskSheet = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button(action: { withAnimation { isRightSideMenuOpen.toggle() } }) {
                                Image(systemName: "ellipsis")
                                    .font(.title)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(width: UIScreen.main.bounds.width - 20, height: 65)
                        .background(Color(UIColor.systemBackground).clipShape(RoundedRectangle(cornerRadius: 16)).shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: -2))
                        .padding(.bottom, 0)
                        .zIndex(1)
                    }
                    
                    if isLeftSideMenuOpen {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture { withAnimation { isLeftSideMenuOpen = false } }
                        SideMenuLeftView(isSideMenuOpen: $isLeftSideMenuOpen,
                                     onProfileTap: {
                            print("Profile tapped")
                            isProfileMenuOpen = true
                        },
                                     onCalendarTap: {
                            showCalendarSheet = true
                        })
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                    }
                    
                    if isRightSideMenuOpen {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture { withAnimation { isRightSideMenuOpen = false } }
                        SideMenuRightView(isSideMenuOpen: $isRightSideMenuOpen)
                            .transition(.move(edge: .trailing))
                            .zIndex(2)
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showAddTaskSheet) {
                    AddTaskView()
                        .environmentObject(taskViewModel)
                        .environment(\.managedObjectContext, TaskManager.shared.viewContext)
                        .presentationDetents([.fraction(0.75)])
                }
                .sheet(isPresented: $isProfileMenuOpen) {
                    if let user = user {
                        ProfileView(user: user, logout: self.logout)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    taskViewModel.sortTasks()}
                .sheet(isPresented: $showCalendarSheet) {
                    CalendarView()
                }
            }
        }
    }
}

extension ContentView {
    func login() {
        print("login called in extension")
        Auth0
            .webAuth()
            .useEphemeralSession() // No SSO, therefore no alert box
            .parameters(["prompt": "login"]) // Ignore the cookie (if present) and show the login page
        //.useHTTPS() // Uncomment if needed for iOS 17.4+ / macOS 14.4+
            .start { result in
                switch result {
                case .success(let credentials):
                    DispatchQueue.main.async {
                        if let newUser = User(from: credentials.idToken) {
                            print("User successfully parsed: \(newUser)")
                            self.user = newUser
                        } else {
                            print("Failed to parse user from token")
                        }
                    }
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    func logout() {
        Auth0
            .webAuth()
        //.useHTTPS() // Use if needed for iOS 17.4+ / macOS 14.4+
            .useEphemeralSession() // No SSO, therefore no alert box
            .parameters(["prompt": "logout"])
            .clearSession { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.user = nil
                    }
                case .failure(let error):
                    print("Logout failed with: \(error)")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let previewModel = TaskViewModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(previewModel)
    }
}
