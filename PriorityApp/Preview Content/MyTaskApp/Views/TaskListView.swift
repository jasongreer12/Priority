import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        List {
            ForEach(taskViewModel.tasks) { task in
                TaskRowView(task: task)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let task = taskViewModel.tasks[index]
                    taskViewModel.deleteTask(task)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .environmentObject(TaskViewModel())
    }
}
