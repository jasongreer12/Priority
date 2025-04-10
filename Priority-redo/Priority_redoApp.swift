//
//  Priority_redoApp.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

@main
struct Priority_redoApp: App {
    @StateObject private var taskViewModel = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
                .environment(\.managedObjectContext, TaskManager.shared.viewContext)
        }
    }
}
