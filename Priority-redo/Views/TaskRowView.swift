//
//  TaskRowView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskRowView: View {
    //@EnvironmentObject var taskViewModel: TaskViewModel
    //var task: TaskModel
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var task: Task

    var body: some View {
        HStack {
            // Tapping the icon or row toggles completion.
            Button(action: {
                //taskViewModel.toggleTaskCompletion(task)
                toggleComplete()
            }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .gray)
                    .font(.title)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(task.title)
                .foregroundColor(task.isComplete ? .gray : .primary)
                .strikethrough(task.isComplete, color: .gray)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes the entire row tappable.
        .onTapGesture {
            //taskViewModel.toggleTaskCompletion(task)
            toggleComplete()
        }
        // Leading swipe: mark complete.
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                //taskViewModel.toggleTaskCompletion(task)
                toggleComplete()
            } label: {
                Label("Complete", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
        }
        // Trailing swipe: delete task.
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                //taskViewModel.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }
}

private extension TaskRowView {
    func toggleComplete() {
        task.isComplete.toggle()
        do{
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error)
        }
    }
}

/*struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task())
            .environmentObject(TaskViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
*/
