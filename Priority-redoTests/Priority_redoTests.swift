//
//  Priority_redoTests.swift
//  Priority-redoTests
//
//  Created by Erin Dunlap on 4/11/25.
//

import XCTest
@testable import Priority_redo

final class TaskViewModelTests: XCTestCase {
    
    var viewModel: TaskViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TaskViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddTaskIncreasesCount() {
        viewModel.addTask(title: "New Task", details: "Some details")
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "New Task")
    }

    func testToggleTaskCompletion() {
        viewModel.addTask(title: "Toggle Test")
        var task = viewModel.tasks[0]
        XCTAssertFalse(task.isCompleted)

        viewModel.toggleTaskCompletion(task)
        task = viewModel.tasks[0] // get updated task
        XCTAssertTrue(task.isCompleted)

        viewModel.toggleTaskCompletion(task)
        task = viewModel.tasks[0]
        XCTAssertFalse(task.isCompleted)
    }

    func testDeleteTaskRemovesCorrectTask() {
        viewModel.addTask(title: "Task 1")
        viewModel.addTask(title: "Task 2")
        let taskToDelete = viewModel.tasks[0]

        viewModel.deleteTask(taskToDelete)

        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertFalse(viewModel.tasks.contains(where: { $0.id == taskToDelete.id }))
    }

    func testUpdateTaskChangesTitleAndDetails() {
        viewModel.addTask(title: "Old Title", details: "Old details")
        var task = viewModel.tasks[0]

        viewModel.updateTask(task, title: "New Title", details: "New details")
        task = viewModel.tasks[0]

        XCTAssertEqual(task.title, "New Title")
        XCTAssertEqual(task.details, "New details")
    }

    func testCompletionPercentageEmptyTasksReturnsOne() {
        XCTAssertEqual(viewModel.completionPercentage, 1.0)
    }

    func testCompletionPercentageSomeCompleted() {
        viewModel.addTask(title: "One")
        viewModel.addTask(title: "Two")
        viewModel.toggleTaskCompletion(viewModel.tasks[0]) // complete one

        XCTAssertEqual(viewModel.completionPercentage, 0.5)
    }

    func testCompletionPercentageAllCompleted() {
        viewModel.addTask(title: "A")
        viewModel.addTask(title: "B")
        viewModel.tasks.indices.forEach {
            viewModel.toggleTaskCompletion(viewModel.tasks[$0])
        }

        XCTAssertEqual(viewModel.completionPercentage, 1.0)
    }
}
