//
//  AppConfig.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import SwiftUI
import Combine

class AppConfig: ObservableObject {
    @AppStorage("showDueDates")
    var showDueDates: Bool = true

    @AppStorage("showPriorities")
    var showPriorities: Bool = true

    @AppStorage("enableReminders")
    var enableReminders: Bool = true
}
