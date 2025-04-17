//
//  CalendarView.swift
//  Priority
//
//  Created by Karter Caves on 4/15/25.
//

import SwiftUI

struct IdentifiableDate: Identifiable, Equatable {
    let date: Date
    var id: Date { date }
}

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: IdentifiableDate? = nil

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        NavigationView {
            VStack {
                header
                    .padding(.horizontal)

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
                                    selectedDate = IdentifiableDate(date: date)
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
            .sheet(item: $selectedDate) { identifiable in
                TasksForDayView(
                    date: identifiable.date,
                    tasks: tasksForDate(identifiable.date)
                )
                .environmentObject(taskViewModel)
            }
        }
    }

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

        let offset = firstWeekday - 1

        if offset > 0,
           let previousMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth),
           let previousRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let totalDaysPrevious = previousRange.count
            for day in (totalDaysPrevious - offset + 1)...totalDaysPrevious {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    dates.append(date)
                }
            }
        }

        if let range = calendar.range(of: .day, in: .month, for: displayedMonth) {
            for day in range {
                if let date = calendar.date(bySetting: .day, value: day, of: displayedMonth) {
                    dates.append(date)
                }
            }
        }

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
            calendar.isDate(task.dueDate ?? Date(), inSameDayAs: date)
        }
    }

    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return taskViewModel.tasks.filter { task in
            calendar.isDate(task.dueDate ?? Date(), inSameDayAs: date)
        }
    }
}

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

    func isCurrentMonth(date: Date) -> Bool {
        let current = Calendar.current.dateComponents([.month, .year], from: Date())
        let other = Calendar.current.dateComponents([.month, .year], from: date)
        return current == other
    }
}
