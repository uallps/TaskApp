class MockStorageProvider: StorageProvider {
    private var storedTasks: [Task] = [
        Task(title: "Mock Task 1"),
        Task(title: "Mock Task 2", isCompleted: true)
    ]
    
    func loadTasks() async throws -> [Task] {
        return storedTasks
    }
    
    func saveTasks(tasks: [Task]) async throws {
        storedTasks = tasks
    }
}
