import Combine
import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    @Published private(set) var locations: [Location] = []
    @Published private(set) var loadState: LoadState = .idle
    
    private let locationsService: LocationService
    private var loadTask: Task<Void, Never>?
    
    init(locationsService: LocationService) {
        self.locationsService = locationsService
    }
    
    func loadLocations() {
        loadTask = Task {
            do {
                let fetched = try await locationsService.fetchLocations()
                locations = fetched
                loadState = .loaded
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                loadState = .failed(message)
            }
        }
    }
    
    func addLocation(_ location: Location) {
        locations.append(location)
    }
}


