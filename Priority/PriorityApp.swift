//
//  PriorityApp.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

@main
struct Priority_redoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, TaskManager.shared.viewContext)
        }
    }
}
