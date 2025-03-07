import Foundation

struct TaskModel: Identifiable {
    let id: UUID
    var title: String
    var details: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, details: String = "", isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
    }
}
