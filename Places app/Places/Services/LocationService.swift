import Foundation


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



enum LocationsServiceError: Error, Equatable, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case network(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The locations URL is invalid."
        case .invalidResponse:
            return "The server returned an unexpected response."
        case .decodingFailed:
            return "Could not parse the locations list."
        case .network(let message):
            return message
        }
    }
}
