//
//  TaskListView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    var body: some View {
        VStack {
            Picker("Sort Mode", selection: $taskViewModel.sortMode) {
                Text("Custom").tag(TaskSortMode.custom)
                Text("Prioritized").tag(TaskSortMode.prioritized)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                ForEach(taskViewModel.displayedTasks, id: \.objectID) { task in
                    TaskRowView(task: task)
                }
                .onMove(perform: taskViewModel.sortMode == .custom ? taskViewModel.reorderTasks : { _, _ in })
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            taskViewModel.fetchTasks(context: TaskManager.shared.viewContext)
        }
        .onChange(of: taskViewModel.sortMode) {
            taskViewModel.fetchTasks(context: TaskManager.shared.viewContext)
        }
        .toolbar {
            EditButton()
        }
    }
}

//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListView()
//            .environmentObject(TaskViewModel())
//    }
//}
