//
//  TaskListViewModel.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import Combine
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Comprar leche", dueDate: Date().addingTimeInterval(86400)),
        Task(title: "Hacer ejercicio", priority: .high),
        Task(title: "Llamar a mamá")
    ]
    
    func addTask(task: Task) {
        tasks.append(task)
    }

    func removeTasks(atOffsets offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func toggleCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}
