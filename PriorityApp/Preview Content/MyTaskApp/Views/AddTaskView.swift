import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var title: String = ""
    @State private var details: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
            }
            
            Button(action: {
                // Add new task
                taskViewModel.addTask(title: title, details: details)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .disabled(title.isEmpty)
        }
        .navigationTitle("Add Task")
        // No special code needed here for 3/4 coverage
        // The .sheet call in ContentView controls the height.
    }
}
