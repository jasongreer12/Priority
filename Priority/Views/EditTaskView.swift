//
//  EditTaskView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()
    @State private var selectedCategory: Category?
    @State private var newCategoryTitle: String = ""
    @State private var estimatedHours: Int = 0
    @State private var estimatedQuarterHour: Int = 0
    @State private var newCategoryPriority: Int = 5
    @State private var priority: Int = 0
    
    private func totalEstimatedSeconds() -> NSNumber? {
        let totalMinutes = (estimatedHours * 60) + estimatedQuarterHour
        return totalMinutes > 0 ? NSNumber(value: totalMinutes * 60) : nil
    }
    
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
        _priority = State(initialValue: Int(existingTask?.priority?.intValue ?? 0))
    }
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [])
    private var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Title", text: $title)
                }
                
                Section(header: Text("Due Date")) {
                    Toggle("Add Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Estimated Time to Complete")) {
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
                
                Section(header: Text("Priority Score")) {
                    VStack(alignment: .leading) {
                        Text(priority == 0 ? "Priority: 0" : "Priority: \(priority)")
                        Slider(value: Binding(
                            get: { Double(priority) },
                            set: { priority = Int($0) }
                        ), in: 0...10, step: 1)
                    }
                }
            }
            .navigationTitle(existingTask == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        taskViewModel.saveTask(
                            existingTask: existingTask,
                            title: title,
                            details: details,
                            dueDate: hasDueDate ? dueDate : nil,
                            estimatedTimeSeconds: totalEstimatedSeconds(),
                            category: selectedCategory,
                            priority: priority,
                            newCategoryTitle: newCategoryTitle,
                            newCategoryPriority: newCategoryPriority,
                            context: context
                        )
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
}
