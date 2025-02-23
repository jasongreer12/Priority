import SwiftUI

@main
struct MyTaskApp: App {
    @StateObject private var taskViewModel = TaskViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
        }
    }
}
