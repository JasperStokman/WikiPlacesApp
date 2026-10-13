import SwiftUI

struct CustomLocationView: View {
    @ObservedObject var viewModel: CustomLocationViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField(Localized.optionalName, text: $viewModel.name)
                TextField(Localized.latitude, text: $viewModel.latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField(Localized.longitude, text: $viewModel.longitude)
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
        .navigationTitle(Localized.customLocation)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Localized.cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(Localized.add) {
                    viewModel.addCustomLocation()
                    dismiss()
                }
            }
        }
    }
}
