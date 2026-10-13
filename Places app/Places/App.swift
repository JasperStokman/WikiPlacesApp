import SwiftUI

@main struct Root: App {
    var body: some Scene {
        WindowGroup {
            LocationsListView(
                viewModel: LocationsViewModel(
                    locationsService: LocationsAPIService())
            )
        }
    }
}
