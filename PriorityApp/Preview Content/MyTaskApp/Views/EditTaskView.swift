import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let task: TaskModel
    
    @State private var title: String
    @State private var details: String
    
    init(task: TaskModel) {
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
                // Update the existing task
                taskViewModel.updateTask(task, title: title, details: details)
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
