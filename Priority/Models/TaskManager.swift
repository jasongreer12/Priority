//
//  TaskManager.swift
//  Priority
//
//  Created by Joshua Wyckoff on 4/10/25.
//

import Foundation
import CoreData

final class TaskManager {
    static let shared = TaskManager()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TasksDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Undable to lead store with error: \(error)")
            }
        }
    }
}
