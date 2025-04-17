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
