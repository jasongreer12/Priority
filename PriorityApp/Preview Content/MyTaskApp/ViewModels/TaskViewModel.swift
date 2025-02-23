import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    
    // Compute progress as the fraction of tasks completed.
    // - If no tasks exist, return 1.0 (fully filled ring).
    // - Otherwise, progress is (# completed tasks / total tasks).
    var completionPercentage: Double {
        if tasks.isEmpty {
            return 1.0
        } else {
            let completedCount = tasks.filter { $0.isCompleted }.count
            return Double(completedCount) / Double(tasks.count)
        }
    }
    
    func addTask(title: String, details: String = "") {
        let newTask = TaskModel(title: title, details: details)
        tasks.append(newTask)
    }
    
    func toggleTaskCompletion(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
    }
    
    func deleteTask(_ task: TaskModel) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func updateTask(_ task: TaskModel, title: String, details: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].title = title
        tasks[index].details = details
    }
}
