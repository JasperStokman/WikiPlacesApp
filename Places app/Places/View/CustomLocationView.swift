import SwiftUI

struct CustomLocationView: View {
    @ObservedObject var viewModel: CustomLocationViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField("Name (optional)", text: $viewModel.name)
                TextField("Latitude", text: $viewModel.latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Longitude", text: $viewModel.longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            if let customLocationError = viewModel.locationError {
                Section {
                    Text(customLocationError)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Custom location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    viewModel.addCustomLocation()
                    dismiss()
                }
            }
        }
    }
}
