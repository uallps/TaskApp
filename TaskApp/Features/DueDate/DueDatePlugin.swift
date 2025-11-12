//
//  DueDatePlugin.swift
//  TaskApp
//
//  Created by Francisco José García García on 11/11/25.
//
import Foundation
import SwiftData

/// Plugin que gestiona las fechas de vencimiento de las tareas
class DueDatePlugin: DataPlugin {
    
    // MARK: - FeaturePlugin Properties
    
    var models: [any PersistentModel.Type] {
        return [TaskDueDate.self]
    }
    
    var isEnabled: Bool {
        return config.showDueDates
    }
    
    // MARK: - Private Properties
    
    private let config: AppConfig
    
    // MARK: - Initialization
    
    required init(config: AppConfig) {
        self.config = config
        print("🗓️ DueDatePlugin inicializado - Habilitado: \(isEnabled)")
    }
    
    // MARK: - DataPlugin Methods
    
    /// Se llama cuando se va a eliminar una tarea
    /// Limpia todos los TaskDueDate asociados a la tarea
    func willDeleteTask(_ task: Task) async {
        guard isEnabled else { return }
        
        guard let context = SwiftDataContext.shared else {
            print("⚠️ DueDatePlugin: No hay contexto SwiftData disponible")
            return
        }
        
        do {
            // Buscar todos los TaskDueDate asociados a esta tarea
            let descriptor = FetchDescriptor<TaskDueDate>(
                predicate: #Predicate { $0.taskUid == task.id }
            )
            
            let dueDates = try context.fetch(descriptor)
            
            if !dueDates.isEmpty {
                print("🗑️ DueDatePlugin: Eliminando \(dueDates.count) fecha(s) de vencimiento para tarea '\(task.title)'")
                
                for dueDate in dueDates {
                    context.delete(dueDate)
                }
                
                try context.save()
                print("✅ DueDatePlugin: Fechas de vencimiento eliminadas correctamente")
            }
            
        } catch {
            print("❌ DueDatePlugin: Error al eliminar fechas de vencimiento: \(error)")
        }
    }
    
    /// Se llama después de que una tarea ha sido eliminada
    /// Puede usarse para limpieza adicional o notificaciones
    func didDeleteTask(taskId: UUID) async {
        guard isEnabled else { return }
        
        // Aquí podríamos hacer limpieza adicional, logging, notificaciones, etc.
        print("📝 DueDatePlugin: Tarea \(taskId) eliminada completamente")
    }
}
