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
    @Published private(set) var onOpenError: String?
    
    private let locationsService: LocationService
    private let wikiRouting: WikipediaOpening
    
    private var loadTask: Task<Void, Never>?
    
    init(locationsService: LocationService, wikiRouting: WikipediaOpening) {
        self.locationsService = locationsService
        self.wikiRouting = wikiRouting
    }
    
    func loadLocations() {
        loadTask?.cancel()
        loadState = .loading
        onOpenError = nil

        loadTask = Task {
            do {
                let fetchedLocations = try await locationsService.getLocations()
                guard !Task.isCancelled else { return }

                // Make sure only locations with name are visible
                locations = fetchedLocations.filter { location in
                    guard let name = location.name else {
                        return false
                    }

                    return !name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                }
                loadState = .loaded
            } catch {
                guard !Task.isCancelled else { return }
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                loadState = .failed(message)
            }
        }
    }
    
    func addLocation(_ location: Location) {
        locations.append(location)
    }
}

extension LocationsViewModel {
    
    func open(_ location: Location) {
        onOpenError = nil
        Task {
            let didOpen = await wikiRouting.openLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )

            if !didOpen {
                onOpenError = "Could not open Wikipedia. Please install the modified wikipedia app"
            }
        }
    }
}
