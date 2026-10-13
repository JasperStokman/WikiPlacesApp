import Combine
import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    
    @Published private(set) var locations: [Location] = []
    
    private let locationsService: LocationService

    
    init(locationsService: LocationService) {
        self.locationsService = locationsService
    }
    
}


