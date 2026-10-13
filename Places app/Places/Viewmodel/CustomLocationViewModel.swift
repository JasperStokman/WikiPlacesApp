import Combine
import Foundation

@MainActor
final class CustomLocationViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var locationError: String?
    
    var onAdd: ((Location) -> Void)?
    
    func addCustomLocation() {
        locationError = nil
 
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let latitude = Double(latitude.trimmingCharacters(in: .whitespacesAndNewlines)),
              let longitude = Double(longitude.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            locationError = Localized.wrongInputErrorMessage
            return
        }

        guard (-90...90).contains(latitude), (-180...180).contains(longitude) else {
            locationError = Localized.rangeError
            return
        }

        let location = Location(
            name: trimmedName.isEmpty ? nil : trimmedName,
            latitude: latitude,
            longitude: longitude
        )
        addToList(location)
    }
    
    func addToList(_ location: Location) {
        onAdd?(location)
    }
}
