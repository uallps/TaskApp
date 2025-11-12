//
//  AppConfig.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import SwiftUI
import SwiftData
import Combine

class AppConfig: ObservableObject {
    @AppStorage("showDueDates")
    var showDueDates: Bool = true

    @AppStorage("showPriorities")
    var showPriorities: Bool = true

    @AppStorage("enableReminders")
    var enableReminders: Bool = true

    @AppStorage("storageType")
    var storageType: StorageType = .json

    // MARK: - Plugin Management
    
    private var plugins: [FeaturePlugin] = []
    
    init() {
        // Registrar plugins disponibles al inicializar
        PluginRegistry.shared.register(DueDatePlugin.self)
        
        // Crear instancias de los plugins
        self.plugins = PluginRegistry.shared.createPluginInstances(config: self)
    }

    // MARK: - Storage Provider
    
    private lazy var swiftDataProvider: SwiftDataStorageProvider = {
        // Obtener modelos base
        var schemas: [any PersistentModel.Type] = [Task.self]
        
        // Agregar modelos de plugins habilitados
        schemas.append(contentsOf: PluginRegistry.shared.getEnabledModels(from: plugins))
        
        let schema = Schema(schemas)
        print("📦 Schemas registrados: \(schemas)")
        print("🔌 Plugins activos: \(plugins.filter { $0.isEnabled }.count)/\(plugins.count)")
        
        return SwiftDataStorageProvider(schema: schema)
    }()

    var storageProvider: StorageProvider {
        switch storageType {
        case .swiftData:
            return swiftDataProvider
        case .json:
            return JSONStorageProvider.shared
        }
    }
}

enum StorageType: String, CaseIterable, Identifiable {
    case swiftData = "SwiftData Storage"
    case json = "JSON Storage"

    var id: String { self.rawValue }
}
