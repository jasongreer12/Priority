//
//  AddTaskView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var dueDate: Date = Date() // New state property for due date

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
            }
            
            Section(header: Text("Due Date")) {
                DatePicker("Select due date", selection: $dueDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            Button(action: {
                // Create a new task with the selected due date.
                let newTask = TaskModel(title: title,
                                        details: details,
                                        isCompleted: false,
                                        dueDate: dueDate)
                                    
                taskViewModel.addTask(title: title, dueDate: dueDate)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .disabled(title.isEmpty)
        }
        .navigationTitle("Add Task")
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskViewModel())
    }
}
