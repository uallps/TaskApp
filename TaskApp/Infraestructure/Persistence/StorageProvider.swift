protocol StorageProvider {
    func loadTasks() async throws -> [Task]
    func saveTasks(tasks: [Task]) async throws
}
