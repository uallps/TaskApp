//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//

import SwiftUI

@main
struct TaskApp: App {
    @State private var selectedDetailView: String?

    var body: some Scene {
        WindowGroup{
            #if os(iOS) 
            TabView {
                TaskListView()
                    .tabItem {
                        Label("Tareas", systemImage: "checklist")
                    }
                SettingsView()
                    .tabItem {
                        Label("Ajustes", systemImage: "gearshape")
                    }
            }
            .environmentObject(AppConfig())
            #else
            NavigationSplitView {
                List(selection: $selectedDetailView) {
                    NavigationLink(value: "tareas") {
                        Label("Tareas", systemImage: "checklist")
                    }
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selectedDetailView {
                case "tareas":
                    TaskListView()
                case "ajustes":
                    SettingsView()
                default:
                    Text("Seleccione una opción")
                }
            }.environmentObject(AppConfig())
            #endif
        }
    }
}
