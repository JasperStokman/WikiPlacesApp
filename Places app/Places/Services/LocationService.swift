import Foundation

protocol LocationService {
    func getLocations() async throws -> [Location]
}

struct LocationsAPIService: LocationService {
    private let network: NetworkServing

    init(network: NetworkServing = NetworkService.shared) {
        self.network = network
    }

    func getLocations() async throws -> [Location] {
        guard let url = NetworkService.Endpoints.locations else {
            throw NetworkError.invalidURL
        }

        let response = try await network.fetch(LocationsResponse.self, from: url)
        return response.locations
    }
}
