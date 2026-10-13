import Foundation

enum Localized {
    static let optionalName = "Name (optional)"
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let customLocation = "Custom location"
    static let cancel = "Cancel"
    static let add = "Add"
    static let tapLocation = "Tap a location to open it in the Wikipedia Places map."
    static let places = "Places"
}

// Error messages
extension Localized {
    static let wrongInputErrorMessage = "Enter valid latitude and longitude values."
    static let invalidURL = "The locations URL is invalid."
    static let invalidResponse = "The server returned an unexpected response."
    static let decodingFailed = "Could not parse the locations list."
    static let rangeError = "Latitude must be between -90 and 90, longitude between -180 and 180."
}
