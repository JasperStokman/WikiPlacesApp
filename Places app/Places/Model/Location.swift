import Foundation

struct LocationsResponse: Decodable, Equatable, Sendable {
    let locations: [Location]
}

struct Location: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String?
    let latitude: Double
    let longitude: Double
    
    var displayedName: String {
        if let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name
        }
        return ""
    }

    init(id: UUID = UUID(), name: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decodeIfPresent(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
