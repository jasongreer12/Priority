//
//  CalendarView.swift
//  Priority-redo
//
//  Created by [Your Name] on [Today's Date].
//

import SwiftUI

// MARK: - Make Date Identifiable
extension Date: Identifiable {
    public var id: TimeInterval {
        self.timeIntervalSince1970
    }
}

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = nil  // Tracks the tapped date with tasks

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        NavigationView {
            VStack {
                header
                    .padding(.horizontal)
                
                // Calendar grid with weekday headers.
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(weekdaySymbols(), id: \.self) { symbol in
                        Text(symbol)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(daysInMonth(), id: \.self) { date in
                        let has = hasTask(on: date)
                        DayView(date: date, hasTask: has)
                            .onTapGesture {
                                if has {
                                    selectedDate = date
                                }
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            // Present a sheet when a highlighted date is tapped.
            .sheet(item: $selectedDate) { date in
                TasksForDayView(date: date, tasks: tasksForDate(date))
                    .environmentObject(taskViewModel)
            }
        }
    }
    
    // MARK: - Header
    
    var header: some View {
        HStack {
            Button(action: {
                changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(monthYearString(for: displayedMonth))
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Helper Methods
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
    
    func weekdaySymbols() -> [String] {
        Calendar.current.shortStandaloneWeekdaySymbols
    }
    
    func daysInMonth() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return dates
        }
        
        // Calculate offset based on the weekday of the first day.
        let offset = firstWeekday - 1
        
        // Add previous month's days.
        if offset > 0, let previousMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth),
           let previousRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let totalDaysPrevious = previousRange.count
            for day in (totalDaysPrevious - offset + 1)...totalDaysPrevious {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    dates.append(date)
                }
            }
        }
        
        // Add all days of the current month.
        if let range = calendar.range(of: .day, in: .month, for: displayedMonth) {
            for day in range {
                if let date = calendar.date(bySetting: .day, value: day, of: displayedMonth) {
                    dates.append(date)
                }
            }
        }
        
        // Fill in remaining cells to complete the grid (multiple of 7).
        while dates.count % 7 != 0 {
            if let lastDate = dates.last,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                dates.append(nextDate)
            }
        }
        
        return dates
    }
    
    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func hasTask(on date: Date) -> Bool {
        let calendar = Calendar.current
        return taskViewModel.tasks.contains { task in
            calendar.isDate(task.dueDate, inSameDayAs: date)
        }
    }
    
    func tasksForDate(_ date: Date) -> [TaskModel] {
        let calendar = Calendar.current
        return taskViewModel.tasks.filter { task in
            calendar.isDate(task.dueDate, inSameDayAs: date)
        }
    }
}

/// A day cell that displays the day number with a highlighted circle if any tasks exist.
struct DayView: View {
    var date: Date
    var hasTask: Bool

    var body: some View {
        let day = Calendar.current.component(.day, from: date)
        ZStack {
            if hasTask {
                Circle()
                    .fill(Color.green.opacity(0.4))
                    .frame(width: 30, height: 30)
            }
            Text("\(day)")
                .frame(width: 30, height: 30)
                .foregroundColor(isCurrentMonth(date: date) ? .primary : .gray)
        }
    }
    
    /// Checks if the date belongs to the same month and year as the current date.
    func isCurrentMonth(date: Date) -> Bool {
        let currentComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        let cellComponents = Calendar.current.dateComponents([.month, .year], from: date)
        return currentComponents == cellComponents
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TaskViewModel())
    }
}
