import Combine
import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    
    @Published private(set) var locations: [Location] = []
    
    init(locations: [Location]) {
        self.locations = locations
    }
    
}


