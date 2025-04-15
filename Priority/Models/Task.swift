//
//  Task.swift
//  Priority
//
//  Created by Joshua Wyckoff on 4/10/25.
//

import Foundation
import CoreData

final class Task: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var details: String
    @NSManaged var isComplete: Bool
    @NSManaged var dueDate: Date?
    @NSManaged var estimatedTimeToComplete: NSNumber?
    @NSManaged var sortIndex: Int32
    @NSManaged var taskCategory: Category?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(false, forKey: "isComplete")
    }
}

extension Task {
    private static var tasksFetchRequest: NSFetchRequest<Task> {
        NSFetchRequest(entityName: "Task")
    }
    
    static func all() -> NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = tasksFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Task.sortIndex, ascending: true)
        ]
        return request
    }
    
    var priorityScore: Double {
        let categoryWeight = Double(taskCategory?.priority ?? 0)
        
        // UI: needs to be in increments of 15
        let completionTimeWeight: Double = {
            guard let time = estimatedTimeToComplete?.doubleValue else { return 0 }
            
            let hours = time / 3600
            return min(10, max(0, hours / 1.5))
        }()
        
        let dueDateWeight: Double = {
            guard let due = dueDate else { return 0 }
            
            let now = Date()
            let secondsUntilDue = due.timeIntervalSince(now)
            let hoursUntilDue = max(1, secondsUntilDue / 3600)
            
            if secondsUntilDue < 0 {
                return 10 // overdue tasks
            }
            
            return min(10, max(0, 10 - log(hoursUntilDue)))
        }()
        
        return categoryWeight + completionTimeWeight + dueDateWeight
    }
}
