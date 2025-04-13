//
//  AddTaskView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()
    @State private var estimatedMinutes: Double = 0 
    @State private var selectedCategory: Category?
    @State private var newCategoryTitle: String = ""
    @State private var estimatedHours: Int = 0
    @State private var estimatedQuarterHour: Int = 0
    @State private var newCategoryPriority: Int = 5
    
    var existingTask: Task?
    
    init(existingTask: Task? = nil) {
        self.existingTask = existingTask
        
        _title = State(initialValue: existingTask?.title ?? "")
        _details = State(initialValue: existingTask?.details ?? "")
        _hasDueDate = State(initialValue: existingTask?.dueDate != nil)
        _dueDate = State(initialValue: existingTask?.dueDate ?? Date())
        
        let seconds = existingTask?.estimatedTimeToComplete?.doubleValue ?? 0
        let totalMinutes = Int(seconds / 60)
        _estimatedHours = State(initialValue: totalMinutes / 60)
        _estimatedQuarterHour = State(initialValue: totalMinutes % 60)
        
        _selectedCategory = State(initialValue: existingTask?.taskCategory)
        _newCategoryTitle = State(initialValue: "")
        _newCategoryPriority = State(initialValue: 5)
    }
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [])
    private var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Title", text: $title)
                    TextField("Details", text: $details)
                }
                
                Section(header: Text("Due Date")) {
                    Toggle("Add Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Estimated Time")) {
                    HStack {
                        Picker("Hours", selection: $estimatedHours) {
                            ForEach(0..<13) { hour in
                                Text("\(hour) hr").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        
                        Picker("Minutes", selection: $estimatedQuarterHour) {
                            ForEach([0, 15, 30, 45], id: \.self) { minute in
                                Text("\(minute) min").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                    }
                    
                    Text("Total: \(estimatedHours) hr \(estimatedQuarterHour) min")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        Text("None").tag(Category?.none)
                        ForEach(categories, id: \.self) { category in
                            Text(category.title ?? "Untitled").tag(Category?.some(category))
                            
                            
                        }
                    }
                    
                    TextField("Or Create New Category", text: $newCategoryTitle)
                    if !newCategoryTitle.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Priority: \(newCategoryPriority)")
                            Slider(value: Binding(
                                get: { Double(newCategoryPriority) },
                                set: { newCategoryPriority = Int($0) }
                            ), in: 0...10, step: 1)
                        }
                    }
                }
            }
            .navigationTitle(existingTask == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        let task = Task(context: context)
        task.id = UUID()
        task.title = title
        task.details = details
        task.isComplete = false
        task.estimatedTimeToComplete = estimatedMinutes > 0 ? NSNumber(value: estimatedMinutes * 60) : nil
        task.dueDate = hasDueDate ? dueDate : nil
        task.sortIndex = Int32(taskViewModel.tasks.count)
        
        if let selected = selectedCategory {
            task.taskCategory = selected
        } else if !newCategoryTitle.isEmpty {
            let newCategory = Category(context: context)
            newCategory.title = newCategoryTitle
            newCategory.priority = 5 // default
            task.taskCategory = newCategory
        }
        
        do {
            try context.save()
            taskViewModel.fetchTasks(context: context)
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
}
