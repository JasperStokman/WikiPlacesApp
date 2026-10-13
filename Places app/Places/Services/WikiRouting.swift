import Foundation
import UIKit

enum WikiRouting {
    static func placesURL(latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "long", value: String(longitude))
        ]
        return components.url
    }
}

@MainActor
protocol WikipediaOpening {
    func openLocation(latitude: Double, longitude: Double) async -> Bool
}

@MainActor
struct WikipediaURLOpener: WikipediaOpening {
    func openLocation(latitude: Double, longitude: Double) async -> Bool {
        guard let url = WikiRouting.placesURL(
            latitude: latitude,
            longitude: longitude
        ) else {
            return false
        }

        return await withCheckedContinuation { continuation in
            UIApplication.shared.open(url, options: [:]) { success in
                continuation.resume(returning: success)
            }
        }
    }
}
