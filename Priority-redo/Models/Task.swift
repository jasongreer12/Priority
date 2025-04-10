//
//  Task.swift
//  Priority-redo
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
    @NSManaged var dueDate: Date
    @NSManaged var estimatedTimeToComplete: Float
    
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
        //Modify Here to sort by priority. Can also sort by other variables too.
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.title, ascending: true)]
        return request
    }
}
