//
//  TaskListView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    // Group tasks by the start of day of their due date.
    private var groupedTasks: [Date: [TaskModel]] {
        let calendar = Calendar.current
        return Dictionary(grouping: taskViewModel.tasks) { task in
            calendar.startOfDay(for: task.dueDate)
        }
    }

    // Sort the grouped dates in ascending order.
    private var sortedDates: [Date] {
        groupedTasks.keys.sorted()
    }

    var body: some View {
        ZStack {
            // Ensures a white background.
            Color.white.ignoresSafeArea()
            
            List {
                // For each date, create a section with that day's header.
                ForEach(sortedDates, id: \.self) { date in
                    Section(header: Text(formatted(date))
                                .foregroundColor(.primary)
                                .listRowBackground(Color.white)
                    ) {
                        ForEach(groupedTasks[date] ?? []) { task in
                            TaskRowView(task: task)
                                .listRowBackground(Color.white)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    // Helper function for formatting the date string.
    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample tasks for preview.
        let sampleTasks = [
            TaskModel(title: "Sample Task A", dueDate: Date()),
            TaskModel(title: "Sample Task B", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
            TaskModel(title: "Sample Task C", dueDate: Date())
        ]
        let viewModel = TaskViewModel()
        viewModel.tasks = sampleTasks
        
        return TaskListView()
            .environmentObject(viewModel)
    }
}
