//
//  EditTaskView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//
import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskViewModel: TaskViewModel

    @ObservedObject var task: Task // 👈 Core Data model

    @State private var title: String
    @State private var details: String

    init(task: Task) {
        self.task = task
        _title = State(initialValue: task.title)
        _details = State(initialValue: task.details)
    }

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
            }

            Button(action: {
                task.title = title
                task.details = details
                taskViewModel.save(context: task.managedObjectContext!)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
            }
            .disabled(title.isEmpty)
        }
        .navigationTitle("Edit Task")
    }
}
