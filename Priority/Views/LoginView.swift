//
//  Login.swift
//  Priority
//
//  Created by Jason Greer on 4/6/25.
//

import SwiftUI
import Auth0
import SimpleKeychain

struct LoginView: View {
    @State var user: User?
    let simpleKeychain = SimpleKeychain(service: "Auth0") // to save user credentials
    
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

extension LoginView {
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
                            do {
                                try simpleKeychain.set(credentials.idToken, forKey: "idToken")
                                try simpleKeychain.set(credentials.accessToken, forKey: "accessToken")
                            }
                            catch {
                                print("Keychain save failed: \(error)")
                                
                            }
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
