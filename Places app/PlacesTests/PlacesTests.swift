import XCTest
@testable import Places

final class LocationDecodingTests: XCTestCase {
    
    func test_Location_Decoding() throws {
        let url = try XCTUnwrap(
            Bundle(for: LocationDecodingTests.self).url(forResource: "locations", withExtension: "json")
        )
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(LocationsResponse.self, from: data)

        XCTAssertEqual(response.locations.count, 4)
        XCTAssertEqual(response.locations[0].name, "Amsterdam")
        XCTAssertEqual(response.locations[0].latitude, 52.3547498, accuracy: 0.0000001)
        XCTAssertEqual(response.locations[0].longitude, 4.8339215, accuracy: 0.0000001)
        
        XCTAssertNil(response.locations[3].name, "")
        XCTAssertEqual(response.locations[3].displayedName, "")
    }
}
