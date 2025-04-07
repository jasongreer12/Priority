//
//  ContentView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//
import SwiftUI
import Auth0

struct ContentView: View {
    @State private var isLeftSideMenuOpen = false
    @State private var isRightSideMenuOpen = false
    @State private var showAddTaskSheet = false
    @State var user: User?  // When nil, user is not logged in.

    var bottomMenuWidth: CGFloat {
        UIScreen.main.bounds.width - 20
    }
    
    var body: some View {
        Group {
            if user == nil {
                // Show a simple login screen when user is not logged in.
                VStack(spacing: 20) {
                    Text("Welcome to Priority!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Please log in to continue.")
                        .foregroundColor(.secondary)
                    Button("Login", action: self.login)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            } else {
                // Main app interface when user is logged in.
                ZStack {
                    HomeView()
                        .edgesIgnoringSafeArea(.all)
                    
                    // Bottom menu overlay pinned to the bottom.
                    VStack {
                        Spacer()
                        HStack {
                            // Left button: toggles left side menu.
                            Button(action: {
                                withAnimation { isLeftSideMenuOpen.toggle() }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Plus button: opens the Add Task sheet.
                            Button(action: { showAddTaskSheet = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Right button: toggles right side menu.
                            Button(action: {
                                withAnimation { isRightSideMenuOpen.toggle() }
                            }) {
                                Image(systemName: "ellipsis")
                                    .font(.title)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(width: bottomMenuWidth, height: 65)
                        .background(
                            Color(UIColor.systemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: -2)
                        )
                        .padding(.bottom, 30)
                        .zIndex(1)
                    }
                    
                    // Left side menu overlay.
                    if isLeftSideMenuOpen {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation { isLeftSideMenuOpen = false }
                            }
                        SideMenuView(isSideMenuOpen: $isLeftSideMenuOpen)
                            .transition(.move(edge: .leading))
                            .zIndex(2)
                    }
                    
                    // Right side menu overlay.
                    if isRightSideMenuOpen {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation { isRightSideMenuOpen = false }
                            }
                        SideMenuRightView(isSideMenuOpen: $isRightSideMenuOpen)
                            .transition(.move(edge: .trailing))
                            .zIndex(2)
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showAddTaskSheet) {
                    AddTaskView()
                        .presentationDetents([.fraction(0.75)])
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskViewModel())
    }
}

extension ContentView {
    func login() {
        Auth0
            .webAuth()
            //.useHTTPS() // Uncomment if needed for iOS 17.4+ / macOS 14.4+
            .start { result in
                switch result {
                case .success(let credentials):
                    DispatchQueue.main.async {
                        self.user = User(from: credentials.idToken)
                    }
                case .failure(let error):
                    print("Login failed with: \(error)")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .useHTTPS() // Use if needed for iOS 17.4+ / macOS 14.4+
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
