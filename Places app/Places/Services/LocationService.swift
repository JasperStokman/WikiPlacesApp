import Foundation

enum LocationsServiceError: Error, Equatable, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case network(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Localized.invalidURL
        case .invalidResponse:
            return Localized.invalidResponse
        case .decodingFailed:
            return Localized.decodingFailed
        case .network(let message):
            return message
        }
    }
}

protocol LocationService {
    func fetchLocations() async throws -> [Location]
}

struct LocationsAPIService: LocationService {
    private let locationURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = JSONDecoder()
    

    func fetchLocations() async throws -> [Location] {
        let data: Data
      
        guard let locationURL else {
            throw LocationsServiceError.invalidURL
        }
        do {
            (data, _) = try await session.data(from: locationURL)
        }
        catch {
            throw LocationsServiceError.network(error.localizedDescription)
        }
        
        do {
            let locationData = try decoder.decode(LocationsResponse.self, from: data)
            return locationData.locations
        }
    }
}
