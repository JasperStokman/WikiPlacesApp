import XCTest
@testable import Places

@MainActor
final class LocationsViewModelTests: XCTestCase {

    func testLoadLocationsSuccess() async {
        let service = MockLocationsService(result: .success([
            Location(name: "Amsterdam", latitude: 52.35, longitude: 4.83),
            Location(name: nil, latitude: 40.0, longitude: -3.0),
            Location(name: "  ", latitude: 1.0, longitude: 2.0)
        ]))
        let router = MockWikipediaRouter()
        let viewModel = LocationsViewModel(locationsService: service, wikiRouting: router)

        viewModel.loadLocations()
        await fulfillment(of: [service.fetchExpectation], timeout: 1.0)
        await waitUntil { viewModel.loadState == .loaded }

        XCTAssertEqual(viewModel.loadState, .loaded)
        XCTAssertEqual(viewModel.locations.count, 1)
        XCTAssertEqual(viewModel.locations.first?.name, "Amsterdam")
    }

    func testLoadLocationsFailurePublishesError() async {
        let service = MockLocationsService(result: .failure(NetworkError.invalidResponse))
        let router = MockWikipediaRouter()
        let viewModel = LocationsViewModel(locationsService: service, wikiRouting: router)

        viewModel.loadLocations()
        await fulfillment(of: [service.fetchExpectation], timeout: 1.0)
        await waitUntil {
            if case .failed = viewModel.loadState { return true }
            return false
        }

        XCTAssertEqual(viewModel.loadState, .failed(Localized.invalidResponse))
        XCTAssertTrue(viewModel.locations.isEmpty)
    }

    func testOpenLocationInvokesWikipediaOpener() async {
        let service = MockLocationsService(result: .success([]))
        let router = MockWikipediaRouter()
        let viewModel = LocationsViewModel(locationsService: service, wikiRouting: router)
        let location = Location(name: "Mumbai", latitude: 19.08, longitude: 72.81)

        viewModel.open(location)
        await waitUntil { !router.openedCoordinates.isEmpty }

        XCTAssertEqual(router.openedCoordinates.count, 1)
        XCTAssertEqual(router.openedCoordinates[0].latitude, 19.08, accuracy: 0.0001)
        XCTAssertEqual(router.openedCoordinates[0].longitude, 72.81, accuracy: 0.0001)
        XCTAssertNil(viewModel.onOpenError)
    }

    func testOpenLocationSetsErrorWhenOpenerFails() async {
        let service = MockLocationsService(result: .success([]))
        let router = MockWikipediaRouter()
        router.shouldSucceed = false
        let viewModel = LocationsViewModel(locationsService: service, wikiRouting: router)

        viewModel.open(Location(name: "Mumbai", latitude: 19.08, longitude: 72.81))
        await waitUntil { viewModel.onOpenError != nil }

        XCTAssertEqual(
            viewModel.onOpenError,
            "Could not open Wikipedia. Please install the modified wikipedia app"
        )
    }

    func testAddLocationAppendsToList() {
        let service = MockLocationsService(result: .success([]))
        let opener = MockWikipediaRouter()
        let viewModel = LocationsViewModel(locationsService: service, wikiRouting: opener)
        let location = Location(name: "Custom", latitude: 52.37, longitude: 4.90)

        viewModel.addLocation(location)

        XCTAssertEqual(viewModel.locations, [location])
    }
}

@MainActor
final class CustomLocationViewModelTests: XCTestCase {

    func testAddCustomLocationValidatesCoordinates() {
        let viewModel = CustomLocationViewModel()
        var didAdd = false
        viewModel.onAdd = { _ in didAdd = true }
        viewModel.latitude = "not-a-number"
        viewModel.longitude = "4.83"

        viewModel.addCustomLocation()

        XCTAssertFalse(didAdd)
        XCTAssertEqual(viewModel.locationError, Localized.wrongInputErrorMessage)
    }

    func testAddCustomLocationRejectsOutOfRangeValues() {
        let viewModel = CustomLocationViewModel()
        var didAdd = false
        viewModel.onAdd = { _ in didAdd = true }
        viewModel.latitude = "100"
        viewModel.longitude = "10"

        viewModel.addCustomLocation()

        XCTAssertFalse(didAdd)
        XCTAssertEqual(viewModel.locationError, Localized.rangeError)
    }

    func testAddCustomLocationSucceeds() {
        let viewModel = CustomLocationViewModel()
        var added: Location?
        viewModel.onAdd = { added = $0 }
        viewModel.name = "Custom"
        viewModel.latitude = "52.37"
        viewModel.longitude = "4.90"

        viewModel.addCustomLocation()

        XCTAssertNil(viewModel.locationError)
        XCTAssertEqual(added?.name, "Custom")
        XCTAssertEqual(added?.latitude ?? 0, 52.37, accuracy: 0.0001)
        XCTAssertEqual(added?.longitude ?? 0, 4.90, accuracy: 0.0001)
    }
}

private extension LocationsViewModelTests {
    func waitUntil(
        _ condition: @escaping @MainActor () -> Bool,
        timeout: TimeInterval = 1.0
    ) async {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition(), Date() < deadline {
            await Task.yield()
        }
    }
}
