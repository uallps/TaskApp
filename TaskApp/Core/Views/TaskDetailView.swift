//
//  TaskDetailView.swift
//  TaskApp
//
//  Created by Francisco José García García on 22/10/25.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var task: Task
    var onSave: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var AppConfig: AppConfig
    @StateObject private var dueDateViewModel: DueDateViewModel
    
    init(task: Binding<Task>, onSave: (() -> Void)? = nil) {
        self._task = task
        self.onSave = onSave
        self._dueDateViewModel = StateObject(wrappedValue: DueDateViewModel(task: task.wrappedValue))
    }
    
    var body: some View {
        HStack() {
            Spacer()
            Form {
                TextField("Título de la tarea", text: $task.title)
                Section(header: Text("Detalles de la Tarea")) {
                    Toggle(isOn: $task.isCompleted) {
                        Text("Completada")
                    }
                    if AppConfig.showDueDates {
                        DueDateDetailView(viewModel: dueDateViewModel)
                    }
                    if AppConfig.showPriorities {
                        Picker("Prioridad", selection: Binding(
                            get: { task.priority },
                            set: { task.priority = $0 }
                        )) {
                            Text("Ninguna").tag(nil as Priority?)
                            Text("Baja").tag(Priority.low)
                            Text("Media").tag(Priority.medium)
                            Text("Alta").tag(Priority.high)
                        }
                    }
                    if AppConfig.enableReminders {
                        Toggle(isOn: Binding(
                            get: { task.reminderDate != nil },
                            set: { newValue in
                                if newValue {
                                    task.reminderDate = Date()
                                } else {
                                    task.reminderDate = nil
                                }
                            }
                        )) {
                            Text("Recordatorio")
                        }
                        if let reminderDate = task.reminderDate {
                            DatePicker("Fecha de Recordatorio", selection: Binding(
                                get: { reminderDate },
                                set: { task.reminderDate = $0 }
                            ), displayedComponents: [.date, .hourAndMinute])
                        }
                    }
                }
            }
            .navigationTitle($task.title)
            .onDisappear {
                onSave?()
            }
        }
        Spacer()
    }
}

#Preview {
    TaskDetailView(task: .constant(Task(title: "Ejemplo de Tarea", isCompleted: false, priority: .high)))
}
