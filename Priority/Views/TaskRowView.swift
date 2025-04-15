//
//  TaskRowView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskRowView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var taskViewModel: TaskViewModel
    @ObservedObject var task: Task
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Button(action: toggleComplete) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .gray)
                    .font(.title)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(task.title)
                .foregroundColor(task.isComplete ? .gray : .primary)
                .strikethrough(task.isComplete, color: .gray)
            
            Spacer()
            
            // DEVELOPMENT ONLY
            Text("\(task.priorityScore, specifier: "%.1f")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            toggleComplete()
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: toggleComplete) {
                Label("Complete", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                isEditing = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
            
            Button(role: .destructive) {
                delete()
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .sheet(isPresented: $isEditing) {
            AddTaskView(existingTask: task)
                .environment(\.managedObjectContext, moc)
                .environmentObject(taskViewModel)
        }
    }
    
    private func toggleComplete() {
        task.isComplete.toggle()
        save()
//        taskViewModel.fetchTasks(context: moc)
        taskViewModel.sortTasks()
    }
    
    private func delete() {
        moc.delete(task)
        save()
        taskViewModel.fetchTasks(context: moc)
    }
    
    private func save() {
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
}

//struct TaskRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = TaskManager.shared.viewContext
//        let task = Task(context: context)
//        task.title = "Task Title"
//        task.isComplete = false
//        
//        return TaskRowView(task: task)
//            .environment(\.managedObjectContext, context)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
