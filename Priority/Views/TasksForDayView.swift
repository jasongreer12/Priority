//
//  TasksForDayView.swift
//  Priority-redo
//
//  Created by Karter Caves on 4/15/25.
//

import SwiftUI

struct TasksForDayView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskViewModel: TaskViewModel
    var date: Date
    var tasks: [Task]

    // Date formatter to display full date.
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks, id: \.id) { task in
                    TaskRowView(task: task)
                        .environmentObject(taskViewModel)
                }
            }
            .navigationTitle(formattedDate)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TasksForDayView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTaskViewModel = TaskViewModel()
        let context = TaskManager.shared.viewContext

        let sampleTask1 = Task(context: context)
        sampleTask1.title = "Sample Task 1"
        sampleTask1.dueDate = Date()
        sampleTask1.isComplete = false

        let sampleTask2 = Task(context: context)
        sampleTask2.title = "Sample Task 2"
        sampleTask2.dueDate = Date()
        sampleTask2.isComplete = true

        return TasksForDayView(date: Date(), tasks: [sampleTask1, sampleTask2])
            .environmentObject(mockTaskViewModel)
    }
}
