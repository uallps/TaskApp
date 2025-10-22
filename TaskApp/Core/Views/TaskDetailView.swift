//
//  TaskDetailView.swift
//  TaskApp
//
//  Created by Francisco José García García on 22/10/25.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var task: Task;
    
    var body: some View {
        Form {
            TextField("Título de la tarea", text: $task.title)
        }
        .navigationTitle($task.title)
    
    }
}

