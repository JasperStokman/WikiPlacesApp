import SwiftUI

struct CustomLocationView: View {
    @ObservedObject var viewModel: CustomLocationViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField(Localized.optionalName, text: $viewModel.name)
                    .accessibilityLabel(Localized.accessibilityNameField)

                TextField(Localized.latitude, text: $viewModel.latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel(Localized.accessibilityLatitudeField)

                TextField(Localized.longitude, text: $viewModel.longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel(Localized.accessibilityLongitudeField)
            }

            if let customLocationError = viewModel.locationError {
                Section {
                    Text(customLocationError)
                        .foregroundStyle(.red)
                        .accessibilityLabel("\(Localized.accessibilityValidationError). \(customLocationError)")
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
                    if viewModel.locationError == nil {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: viewModel.locationError) { _, error in
            guard let error else { return }
            AccessibilityNotification.Announcement(error).post()
        }
    }
}
