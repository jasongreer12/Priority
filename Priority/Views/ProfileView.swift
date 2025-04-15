//
//  ProfileView.swift
//  Priority
//
//  Created by Jason Greer on 4/6/25.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    let logout: () -> Void
    
    var body: some View {
        List {
            Section(header: ProfileHeader(picture: user.picture)) {
                /*ProfileCell(key: "ID", value: user.id)
                 ProfileCell(key: "Name", value: user.name)
                 ProfileCell(key: "Email", value: user.email)*/
                Text("ID: \(user.id)")
                Text("Name: \(user.name)")
                Text("Email: \(user.email)")
            }
            Section {
                Button("Logout") {
                    logout()
                }
                .foregroundColor(.red) // Makes the button red to indicate logout action
            }
        }
    }
}
