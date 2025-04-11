//
//  PriorityApp.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

@main
struct PriorityApp: App {
    @StateObject private var taskViewModel = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
        }
    }
}
