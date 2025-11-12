//
//  PluginRegistry.swift
//  TaskApp
//
//  Created by Francisco José García García on 11/11/25.
//
import Foundation
import SwiftData

/// Protocol que deben implementar todos los plugins de características
protocol FeaturePlugin: AnyObject {
    /// Modelos de datos que el plugin necesita persistir
    var models: [any PersistentModel.Type] { get }
    
    /// Indica si el plugin está habilitado
    var isEnabled: Bool { get }
    
    /// Inicializador requerido para crear instancias del plugin
    /// - Parameter config: Configuración de la aplicación
    init(config: AppConfig)
}

/// Protocol para plugins que gestionan datos y necesitan ser notificados de eventos
protocol DataPlugin: FeaturePlugin {
    /// Se llama cuando se va a eliminar un Task
    /// - Parameter task: La tarea que será eliminada
    func willDeleteTask(_ task: Task) async
    
    /// Se llama después de eliminar un Task
    /// - Parameter taskId: ID de la tarea eliminada
    func didDeleteTask(taskId: UUID) async
}

/// Registro centralizado de plugins de características
class PluginRegistry {
    /// Instancia compartida del registro (Singleton)
    static let shared = PluginRegistry()
    
    /// Array de tipos de plugins registrados
    private(set) var registeredPlugins: [FeaturePlugin.Type] = []
    
    /// Instancias de plugins creadas
    private var pluginInstances: [FeaturePlugin] = []
    
    /// Inicializador privado para el patrón Singleton
    private init() {}
    
    /// Registra un nuevo tipo de plugin
    /// - Parameter pluginType: Tipo del plugin a registrar
    func register(_ pluginType: FeaturePlugin.Type) {
        guard !registeredPlugins.contains(where: { $0 == pluginType }) else {
            print("⚠️ Plugin \(pluginType) ya está registrado")
            return
        }
        
        registeredPlugins.append(pluginType)
        print("✅ Plugin registrado: \(pluginType)")
    }
    
    /// Crea instancias de todos los plugins registrados
    /// - Parameter config: Configuración de la aplicación
    /// - Returns: Array de instancias de plugins
    func createPluginInstances(config: AppConfig) -> [FeaturePlugin] {
        pluginInstances = registeredPlugins.map { pluginType in
            pluginType.init(config: config)
        }
        return pluginInstances
    }
    
    /// Obtiene todos los modelos de los plugins habilitados
    /// - Parameter plugins: Array de instancias de plugins
    /// - Returns: Array de tipos de modelos persistentes
    func getEnabledModels(from plugins: [FeaturePlugin]) -> [any PersistentModel.Type] {
        return plugins.flatMap { plugin in
            plugin.isEnabled ? plugin.models : []
        }
    }
    
    /// Notifica a todos los DataPlugins que una tarea va a ser eliminada
    /// - Parameter task: La tarea que será eliminada
    func notifyTaskWillBeDeleted(_ task: Task) async {
        let dataPlugins = pluginInstances.compactMap { $0 as? DataPlugin }
        
        await withTaskGroup(of: Void.self) { group in
            for plugin in dataPlugins where plugin.isEnabled {
                group.addTask {
                    await plugin.willDeleteTask(task)
                }
            }
        }
    }
    
    /// Notifica a todos los DataPlugins que una tarea ha sido eliminada
    /// - Parameter taskId: ID de la tarea eliminada
    func notifyTaskDidDelete(taskId: UUID) async {
        let dataPlugins = pluginInstances.compactMap { $0 as? DataPlugin }
        
        await withTaskGroup(of: Void.self) { group in
            for plugin in dataPlugins where plugin.isEnabled {
                group.addTask {
                    await plugin.didDeleteTask(taskId: taskId)
                }
            }
        }
    }
    
    /// Limpia todos los plugins registrados (útil para testing)
    func clearAll() {
        registeredPlugins.removeAll()
        pluginInstances.removeAll()
        print("🗑️ Todos los plugins han sido eliminados del registro")
    }
    
    /// Obtiene el número de plugins registrados
    var count: Int {
        return registeredPlugins.count
    }
}
