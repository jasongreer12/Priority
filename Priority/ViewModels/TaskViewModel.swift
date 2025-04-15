//
//  TaskViewModel.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import Foundation
import SwiftUI
import CoreData

enum TaskSortMode: String {
    case custom
    case prioritized
}

class TaskViewModel: ObservableObject {
    @Published private(set) var tasks: [Task] = []
    @Published var sortMode: TaskSortMode = TaskSortMode.loadFromDefaults() {
        didSet {
            sortMode.saveToDefaults()
        }
    }
    
    init() {
        print(" TaskViewModel INIT")
        sortMode = TaskSortMode.loadFromDefaults()
        fetchTasks(context: TaskManager.shared.viewContext)
        sortTasks()
    }
    
    var displayedTasks: [Task] {
        let sorted: [Task]
        switch sortMode {
        case .custom:
            sorted = tasks.sorted { $0.sortIndex < $1.sortIndex }
        case .prioritized:
            sorted = tasks.sorted { $0.priorityScore > $1.priorityScore }
        }
        
        let incomplete = sorted.filter { !$0.isComplete }
        let complete = sorted.filter { $0.isComplete }
        return incomplete + complete
    }
    
    var completionPercentage: Double {
        let total = tasks.count
        let completed = tasks.filter { $0.isComplete }.count
        return total > 0 ? Double(completed) / Double(total) : 0
    }
    
    func fetchTasks(context: NSManagedObjectContext) {
        let request = Task.all()
        do {
            tasks = try context.fetch(request)
            print("Fetched \(tasks.count) tasks with sortMode \(sortMode)")
            for (i, t) in tasks.enumerated() {
                print("\(i): \(t.title) — sortIndex \(t.sortIndex) - priorityScore \(t.priorityScore)")
            }
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
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func updateTask(_ task: Task, title: String, details: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].title = title
        tasks[index].details = details
    }
    
    func sortTasks() {
        print("Sorting tasks with mode: \(sortMode)")
        
        switch sortMode {
        case .custom:
            fetchTasks(context: TaskManager.shared.viewContext)
        case .prioritized:
            tasks = tasks.sorted { $0.priorityScore > $1.priorityScore }
            for (i, t) in tasks.enumerated() {
                print("\(i): \(t.title) — priorityScore: \(t.priorityScore)")
            }
        }
    }
}

extension TaskSortMode {
    private static let key = "selectedSortMode"
    
    static func loadFromDefaults() -> TaskSortMode {
        if let rawValue = UserDefaults.standard.string(forKey: key),
           let mode = TaskSortMode(rawValue: rawValue) {
            return mode
        }
        return .prioritized
    }
    
    func saveToDefaults() {
        UserDefaults.standard.set(self.rawValue, forKey: Self.key)
    }
}
