import Foundation
import SwiftData

class SwiftDataStorageProvider: StorageProvider {

    static let shared = SwiftDataStorageProvider()

    private let modelContainer: ModelContainer
    private let context: ModelContext

    init(){
        do {
            self.modelContainer = try ModelContainer(for: Task.self)
            self.context = ModelContext(self.modelContainer)
        } catch {
            fatalError("Failed to initialize storage provider: \(error)")
       }
    }

    func loadTasks() async throws -> [Task] {
        let descriptor = FetchDescriptor<Task>() // Use FetchDescriptor
        let tasks = try context.fetch(descriptor)
        return tasks
    }

    func saveTasks(tasks: [Task]) async throws {
        let savedTasks = try await self.loadTasks()
        for task in savedTasks {
            context.delete(task)
        }
        for task in tasks {
            context.insert(task)
        }
        try context.save()
    }
}
