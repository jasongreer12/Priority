//
//  Login.swift
//  Priority
//
//  Created by Jason Greer on 4/6/25.
//

import SwiftUI
import Auth0

struct MainView: View {
    @State var user: User?

    var body: some View {
        if let user = self.user {
            VStack {
                ProfileView(user: user, logout: self.logout)
                Button("Logout", action: self.logout)
            }
        } else {
            VStack {
                HomeView()
                Button("Login", action: self.login)
            }
        }
    }
}

extension MainView {
    func login() {
        print("login function called")
        Auth0
            .webAuth()
            //.useEphemeralSession() // No SSO, therefore no alert box
            //.parameters(["prompt": "login"]) // Ignore the cookie (if present) and show the login page
            //.useHTTPS() // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
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
            //.useHTTPS() // Use a Universal Link logout URL on iOS 17.4+ / macOS 14.4+
            .useEphemeralSession() // No SSO, therefore no alert box
            .parameters(["prompt": "logout"])
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}
