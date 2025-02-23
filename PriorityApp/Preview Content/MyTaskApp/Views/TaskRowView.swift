import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    var task: TaskModel

    var body: some View {
        HStack {
            // Tapping the icon or row toggles completion.
            Button(action: {
                taskViewModel.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(task.title)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .strikethrough(task.isCompleted, color: .gray)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes the entire row tappable.
        .onTapGesture {
            taskViewModel.toggleTaskCompletion(task)
        }
        // Leading swipe: mark complete.
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                taskViewModel.toggleTaskCompletion(task)
            } label: {
                Label("Complete", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
        }
        // Trailing swipe: delete task.
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                taskViewModel.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: TaskModel(title: "Sample Task"))
            .environmentObject(TaskViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
