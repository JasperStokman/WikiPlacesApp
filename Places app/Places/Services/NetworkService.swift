import Foundation

enum NetworkError: Error, Equatable, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Localized.invalidURL
        case .invalidResponse:
            return Localized.invalidResponse
        case .decodingFailed:
            return Localized.decodingFailed
        case .requestFailed(let message):
            return message
        }
    }
}

protocol NetworkServing {
    func fetchData(from url: URL) async throws -> Data
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

/// Central place for API endpoints and shared networking used by feature services.
struct NetworkService: NetworkServing {
    static let shared = NetworkService()

    enum Endpoints {
        static let locations = URL(
            string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        )
    }

    private let session: URLSession
    private let decoder: JSONDecoder

    /// Feature services composed on top of this network layer.
    var locationsService: LocationService {
        LocationsAPIService(network: self)
    }

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.invalidResponse
            }
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error.localizedDescription)
        }
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let data = try await fetchData(from: url)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
