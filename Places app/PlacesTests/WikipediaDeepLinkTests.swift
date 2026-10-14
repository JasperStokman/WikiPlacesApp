import XCTest
@testable import Places

final class WikipediaDeepLinkTests: XCTestCase {
    func testPlacesURLUsesLatAndLongQueryItems() throws {
        let url = try XCTUnwrap(
            WikiRouting.placesURL(latitude: 52.3547498, longitude: 4.8339215)
        )

        XCTAssertEqual(url.scheme, "wikipedia")
        XCTAssertEqual(url.host, "places")

        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = Dictionary(
            uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) }
        )
        XCTAssertEqual(items["lat"], "52.3547498")
        XCTAssertEqual(items["long"], "4.8339215")
    }
}
