//
//  TaskViewModel.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import Foundation
import SwiftUI
import CoreData

enum TaskSortMode {
    case custom
    case prioritized
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var sortMode: TaskSortMode = .custom
    
    var displayedTasks: [Task] {
        switch sortMode {
        case .custom:
            return tasks
        case .prioritized:
            return tasks.sorted { $0.priorityScore > $1.priorityScore }
        }
    }
    
    // Compute progress as the fraction of tasks completed.
    // - If no tasks exist, return 1.0 (fully filled ring).
    // - Otherwise, progress is (# completed tasks / total tasks).
    var completionPercentage: Double {
        let total = tasks.count
        let completed = tasks.filter { $0.isComplete }.count
        return total > 0 ? Double(completed) / Double(total) : 0
    }
    
    func fetchTasks(context: NSManagedObjectContext) {
        let request = Task.all()
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func addTask(
        title: String,
        details: String = "",
        isComplete: Bool = false,
        category: Category? = nil,
        dueDate: Date? = nil,
        estimatedTimeToComplete: NSNumber? = nil,
        context: NSManagedObjectContext
    ) {
        let newTask = Task(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.details = details
        newTask.isComplete = isComplete
        newTask.taskCategory = category
        newTask.dueDate = dueDate
        newTask.estimatedTimeToComplete = estimatedTimeToComplete
        newTask.sortIndex = Int32(tasks.count)
        
        do {
            try context.save()
            fetchTasks(context: context)
        } catch {
            print("Failed to add task: \(error)")
        }
    }
    
    func reorderTasks(from source: IndexSet, to destination: Int) {
        var updatedTasks = tasks
        
        updatedTasks.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in updatedTasks.enumerated() {
            task.sortIndex = Int32(index)
        }
        
        do {
            try TaskManager.shared.viewContext.save()
            tasks = updatedTasks
        } catch {
            print("Failed to reorder tasks: \(error)")
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isComplete.toggle()
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func updateTask(_ task: Task, title: String, details: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].title = title
        tasks[index].details = details
    }
    
    func sortTasks() {
        if sortMode == .prioritized {
            tasks = tasks.sorted { $0.priorityScore > $1.priorityScore }
        }
    }
}
