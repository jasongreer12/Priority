//
//  TaskListView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    //May be better way to do this
    @FetchRequest(fetchRequest: Task.all()) private var tasks
    
    var body: some View {
        /*List {
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
        .listStyle(PlainListStyle())*/
        
        List {
            ForEach(tasks, id: \.objectID) { task in
                TaskRowView(task: task)
            }
            /*.onDelete { indexSet in
                indexSet.forEach { index in
                    let task = taskViewModel.tasks[index]
                    taskViewModel.deleteTask(task)
                }
            }*/
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
