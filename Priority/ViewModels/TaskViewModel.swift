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
        sortMode = .prioritized
        fetchTasks(context: TaskManager.shared.viewContext)
        sortTasks()
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
    
    func sortTasks() {
        print("Sorting tasks with mode: \(sortMode)")
        
        let sorted: [Task]
        
        switch sortMode {
        case .custom:
            sorted = tasks.sorted { $0.sortIndex < $1.sortIndex }
        case .prioritized:
            sorted = tasks.sorted { $0.priorityScore > $1.priorityScore }
        }
        
        let incomplete = sorted.filter { !$0.isComplete }
        let complete = sorted.filter { $0.isComplete }
        
        tasks = incomplete + complete
        
        for (i, t) in tasks.enumerated() {
            print("\(i): \(t.title) — priorityScore: \(t.priorityScore)")
        }
    }
    
    private var groupedTasks: [Date: [Task]] {
        let calendar = Calendar.current
        return Dictionary(grouping: tasks) { task in
            calendar.startOfDay(for: task.dueDate ?? Date())
        }
    }
    
    private var sortedDates: [Date] {
        groupedTasks.keys.sorted()
    }
    
    func saveTask(
        existingTask: Task? = nil,
        title: String,
        details: String,
        dueDate: Date?,
        estimatedTimeSeconds: NSNumber?,
        category: Category?,
        priority: Int?,
        newCategoryTitle: String?,
        newCategoryPriority: Int,
        context: NSManagedObjectContext
    ) {
        let task = existingTask ?? Task(context: context)
        
        if existingTask == nil {
            task.id = UUID()
            task.isComplete = false
            task.sortIndex = Int32(tasks.count)
        }
        
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.estimatedTimeToComplete = estimatedTimeSeconds
        task.priority = NSNumber(value: priority ?? 0)
        
        if let category = category {
            task.taskCategory = category
        } else if let title = newCategoryTitle, !title.isEmpty {
            let newCategory = Category(context: context)
            newCategory.title = title
            newCategory.priority = Int32(newCategoryPriority)
            task.taskCategory = newCategory
        }
        
        do {
            try context.save()
            fetchTasks(context: context)
            sortTasks()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
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
