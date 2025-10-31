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
                        Toggle(isOn: Binding(
                            get: { task.dueDate != nil },
                            set: { newValue in
                                if newValue {
                                    task.dueDate = Date()
                                } else {
                                    task.dueDate = nil
                                }
                            }
                        )) {
                            Text("Vencimiento")
                        }
                        if let dueDate = task.dueDate {
                            DatePicker("Fecha de Vencimiento", selection: Binding(
                                get: { dueDate },
                                set: { task.dueDate = $0 }
                            ), displayedComponents: .date)
                        }
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
    TaskDetailView(task: .constant(Task(title: "Ejemplo de Tarea", isCompleted: false, dueDate: Date(), priority: .high)))
}
