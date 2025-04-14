//
//  EditTaskViewModel.swift
//  Priority
//
//  Created by Joshua Wyckoff on 4/10/25.
//

import Foundation
import CoreData
import SwiftUI

final class EditTaskViewModel: ObservableObject {
    @Published var task: Task
    
    private let context: NSManagedObjectContext
    
    init(manager: TaskManager, task: Task? = nil) {
        self.context = manager.newContext
        self.task = Task(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
        try context.save()
    }
}
