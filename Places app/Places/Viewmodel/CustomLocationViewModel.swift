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
            locationError = "Enter valid latitude and longitude values."
            return
        }

        guard (-90...90).contains(latitude), (-180...180).contains(longitude) else {
            locationError = "Latitude must be between -90 and 90, longitude between -180 and 180."
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
