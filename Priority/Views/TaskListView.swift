//
//  TaskListView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack {
            if taskViewModel.tasks.isEmpty {
                Text("No tasks yet!")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(taskViewModel.tasks, id: \.objectID) { task in
                        TaskRowView(task: task)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onChange(of: taskViewModel.sortMode) {
            if taskViewModel.sortMode == .custom {
                taskViewModel.fetchTasks(context: TaskManager.shared.viewContext)
            } else {
                taskViewModel.sortTasks()
            }
        }
        .toolbar {
            EditButton()
        }
    }
}
