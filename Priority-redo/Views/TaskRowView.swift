//
//  TaskRowView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    var task: TaskModel

    // State to control the presentation of the edit sheet.
    @State private var isEditing = false

    var body: some View {
        HStack {
            // Complete Button (tapping this toggles completion)
            Button(action: {
                taskViewModel.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Task Title
            Text(task.title)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .strikethrough(task.isCompleted, color: .gray)
            
            Spacer()
            
            // Due date, shown on the right.
            Text(task.dueDate, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Edit Button (only triggers edit when pressed)
            Button {
                isEditing = true
            } label: {
                Label("", systemImage: "pencil.circle")
            }
            .tint(.gray)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes the entire row tappable for swipe actions, but we removed onTapGesture.
        // Swipe Actions: leading for complete, trailing for delete.
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                taskViewModel.toggleTaskCompletion(task)
            } label: {
                Label("Complete", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                taskViewModel.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        // Present the EditTaskView as a sheet only when the edit button is pressed.
        .sheet(isPresented: $isEditing) {
            EditTaskView(task: task)
                .environmentObject(taskViewModel)
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: TaskModel(title: "Sample Task", dueDate: Date()))
            .environmentObject(TaskViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
