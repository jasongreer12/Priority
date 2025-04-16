//
//  TaskModel.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import Foundation

struct TaskModel: Identifiable {
    let id: UUID
    var title: String
    var details: String
    var isCompleted: Bool
    var dueDate: Date
    
    init(id: UUID = UUID(), title: String, details: String = "", isCompleted: Bool = false, dueDate: Date) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}
