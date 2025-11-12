//
//  TaskListRowView.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//

import SwiftUI

struct TaskRowView: View {
    
    let task: Task
    let toggleCompletion : () -> Void
    
    @EnvironmentObject private var AppConfig: AppConfig
    
    init(task: Task, toggleCompletion: @escaping () -> Void) {
        self.task = task
        self.toggleCompletion = toggleCompletion
    }
    
    var body: some View {
        HStack {
            Button(action: toggleCompletion){
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }.buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                
                // Vistas proporcionadas por los plugins
                ForEach(Array(PluginRegistry.shared.getTaskRowViews(for: task).enumerated()), id: \.offset) { _, view in
                    view
                }
                
                if AppConfig.showPriorities, let priority = task.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .font(.caption)
                        .foregroundColor(priorityColor(for: priority))
                }
                if AppConfig.enableReminders, let reminderDate = task.reminderDate {
                    Label("Recordatorio: \(reminderDate.formatted(date: .abbreviated, time: .shortened))", systemImage: "bell")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func priorityColor(for priority: Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}
