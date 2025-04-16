//
//  TasksForDayView.swift
//  Priority-redo
//
//  Created by Karter Caves on 4/15/25.
//



import SwiftUI

struct TasksForDayView: View {
    @Environment(\.dismiss) var dismiss
    var date: Date
    var tasks: [TaskModel]
    
    // Date formatter to display full date.
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    // Here you can either use a simpler layout or reuse TaskRowView.
                    // Using TaskRowView for consistency (ensure TaskRowView.swift is updated accordingly).
                    TaskRowView(task: task)
                        .environmentObject(TaskViewModel())
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
        TasksForDayView(date: Date(), tasks: [
            TaskModel(title: "Sample Task 1", dueDate: Date()),
            TaskModel(title: "Sample Task 2", dueDate: Date())
        ])
        .environmentObject(TaskViewModel())
    }
}
