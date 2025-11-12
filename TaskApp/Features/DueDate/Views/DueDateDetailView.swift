import SwiftUI

struct DueDateDetailView: View {
    @ObservedObject var viewModel: DueDateViewModel

    var body: some View {
        Toggle(isOn: Binding(
            get: { viewModel.hasDueDate },
            set: { _ in viewModel.toggleDueDate() }
        )) {
            Text("Vencimiento")
        }
        if viewModel.hasDueDate, let dueDate = viewModel.dueDate {
            DatePicker("Fecha de Vencimiento", selection: Binding(
                get: { dueDate },
                set: { viewModel.setDueDate($0) }
            ), displayedComponents: .date)
        }
    }
}
