import SwiftUI
import Playgrounds

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsViewModel
    
    init(viewModel: LocationsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
