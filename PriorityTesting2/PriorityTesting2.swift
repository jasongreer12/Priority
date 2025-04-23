//
//  PriorityTesting2.swift
//  PriorityTesting2
//
//  Created by Erin Dunlap on 4/23/25.
//

import XCTest
import CoreData
@testable import Priority

final class PriorityTesting2: XCTestCase {

    var viewModel: TaskViewModel!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        viewModel = TaskViewModel()
        context = makeInMemoryContext()
    }

    override func tearDown() {
        viewModel = nil
        context = nil
        super.tearDown()
    }

    func testToggleTaskCompletionFlipsStatus() {
        let task = mockTask(isComplete: false)
        viewModel.tasks = [task]

        viewModel.toggleTaskCompletion(task)

        XCTAssertTrue(viewModel.tasks[0].isComplete)
    }

    func testDeleteTaskRemovesCorrectTask() {
        let task = mockTask()
        viewModel.tasks = [task]

        viewModel.deleteTask(task)

        XCTAssertTrue(viewModel.tasks.isEmpty)
    }

    func testUpdateTaskChangesTitleAndDetails() {
        let task = mockTask(title: "Old Title", details: "Old Details")
        viewModel.tasks = [task]

        viewModel.updateTask(task, title: "New Title", details: "New Details")

        XCTAssertEqual(viewModel.tasks[0].title, "New Title")
        XCTAssertEqual(viewModel.tasks[0].details, "New Details")
    }

    func testCompletionPercentageAllComplete() {
        let task1 = mockTask(isComplete: true)
        let task2 = mockTask(isComplete: true)
        viewModel.tasks = [task1, task2]

        XCTAssertEqual(viewModel.completionPercentage, 1.0)
    }

    func testCompletionPercentageSomeComplete() {
        let task1 = mockTask(isComplete: true)
        let task2 = mockTask(isComplete: false)
        viewModel.tasks = [task1, task2]

        XCTAssertEqual(viewModel.completionPercentage, 0.5)
    }

    func testCompletionPercentageNoneComplete() {
        let task1 = mockTask(isComplete: false)
        let task2 = mockTask(isComplete: false)
        viewModel.tasks = [task1, task2]

        XCTAssertEqual(viewModel.completionPercentage, 0.0)
    }

    func testDisplayedTasksPrioritizedSortsByComputedScore() {
        viewModel.sortMode = .prioritized

        let lowScore = mockTask(
            title: "Low",
            dueDate: Date().addingTimeInterval(3600 * 24), // 24h from now
            estimatedSeconds: 7200, // 2 hours
            categoryPriority: 1
        )

        let highScore = mockTask(
            title: "High",
            dueDate: Date().addingTimeInterval(3600), // 1h from now
            estimatedSeconds: 600, // 10 min
            categoryPriority: 10
        )

        viewModel.tasks = [lowScore, highScore]

        let titles = viewModel.displayedTasks.map { $0.title }
        XCTAssertEqual(titles, ["High", "Low"])
    }

    func testDisplayedTasksCustomReturnsOriginalOrder() {
        viewModel.sortMode = .custom
        let task1 = mockTask(title: "First")
        let task2 = mockTask(title: "Second")
        viewModel.tasks = [task1, task2]

        let titles = viewModel.displayedTasks.map { $0.title }
        XCTAssertEqual(titles, ["First", "Second"])
    }

    func makeInMemoryContext() -> NSManagedObjectContext {
        let model = TaskManager.shared.viewContext.persistentStoreCoordinator!.managedObjectModel

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )

        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }

    func mockTask(
        id: UUID = UUID(),
        title: String = "Mock",
        details: String = "",
        isComplete: Bool = false,
        dueDate: Date? = nil,
        estimatedSeconds: Double? = nil,
        categoryPriority: Int = 0
    ) -> Task {
        let task = Task(context: context)
        task.id = id
        task.title = title
        task.details = details
        task.isComplete = isComplete
        task.dueDate = dueDate

        if let seconds = estimatedSeconds {
            task.estimatedTimeToComplete = NSNumber(value: seconds)
        }

        if categoryPriority > 0 {
            let category = Category(context: context)
            category.priority = Int32(categoryPriority)
            task.taskCategory = category
        }

        return task
    }
}
