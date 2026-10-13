import SwiftUI
import Playgrounds

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsViewModel
    
    init(viewModel: LocationsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                    List {
                        Section {
                            ForEach(viewModel.locations) { location in
                                Button {
                                   
                                } label: {
                                    LocationRowView(location: location)
                                }
                            }
                        } footer: {
                            Text("Tap a location to open it in the Wikipedia Places map.")
                        }
                    }
                    .refreshable {
                        viewModel.loadLocations()
                    }
            }
            .navigationTitle("Places")
        }
        .task {
                viewModel.loadLocations()
        }
    }
}

private struct LocationRowView: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.displayedName)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}
