import XCTest
@testable import Places

final class MockLocationsService: LocationService, @unchecked Sendable {
    let result: Result<[Location], Error>
    let fetchExpectation = XCTestExpectation(description: "fetchLocations")

    init(result: Result<[Location], Error>) {
        self.result = result
    }

    func fetchLocations() async throws -> [Location] {
        defer { fetchExpectation.fulfill() }
        return try result.get()
    }
}

@MainActor
final class MockWikipediaRouter: WikipediaOpening {
    private(set) var openedCoordinates: [(latitude: Double, longitude: Double)] = []
    var shouldSucceed = true

    func openLocation(latitude: Double, longitude: Double) async -> Bool {
        openedCoordinates.append((latitude, longitude))
        return shouldSucceed
    }
}
