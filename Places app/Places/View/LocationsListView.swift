
import SwiftUI

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsViewModel
    @State private var showingCustomLocation = false

    init(viewModel: LocationsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.locations) { location in
                        Button {
                            // viewModel.open(location)
                        } label: {
                            LocationRowView(location: location)
                        }
                    }
                } footer: {
                    Text(
                        "Tap a location to open it in the Wikipedia Places map."
                    )
                }
            }
            .refreshable {
                viewModel.loadLocations()
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCustomLocation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add custom location")
                }
            }
        }
        .task {
            viewModel.loadLocations()
        }
        .sheet(isPresented: $showingCustomLocation) {
            NavigationStack {
                CustomLocationView(
                    viewModel: makeCustomLocationViewModel()
                )
            }
        }
    }

    private func makeCustomLocationViewModel() -> CustomLocationViewModel {
        let customViewModel = CustomLocationViewModel()

        customViewModel.onAdd = { location in
            viewModel.addLocation(location)
            showingCustomLocation = false
        }

        return customViewModel
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
        .contentShape(Rectangle())
    }
}
