import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appConfig: AppConfig

    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Show Due Dates", isOn: $appConfig.showDueDates)
                Toggle("Show Priorities", isOn: $appConfig.showPriorities)
                Toggle("Enable Reminders", isOn: $appConfig.enableReminders)
            }
        }
        .navigationTitle("Settings")
    }
}
