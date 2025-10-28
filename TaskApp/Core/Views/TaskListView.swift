//
//  TaskListView.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel = TaskListViewModel()

    var body: some View {
        VStack{
            NavigationStack{
                List {
                    ForEach($viewModel.tasks) { $task in
                        NavigationLink(destination: TaskDetailView(task: $task)){
                            TaskRowView(task: task, toggleCompletion: {
                                viewModel.toggleCompletion(task:task)
                            }).contextMenu {
                                Button("Eliminar Tarea") {
                                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.removeTasks(atOffsets: IndexSet(integer: index))
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.removeTasks(atOffsets: indexSet)
                    }
                }
                .toolbar {
                    Button("Añadir Tarea") {
                        let newTask = Task(title:"Nueva Tarea")
                        viewModel.addTask(task:newTask)
                    }
                }.navigationTitle("Tareas")
            }
        }
    }
}

#Preview {
    TaskListView()
}
