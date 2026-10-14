
import SwiftUI

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsViewModel
    @StateObject private var customLocationViewModel =
         CustomLocationViewModel()
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
                            viewModel.open(location)
                        } label: {
                            LocationRowView(location: location)
                        }
                        .accessibilityLabel(
                            Localized.accessibilityLocationLabel(
                                name: location.displayedName,
                                latitude: location.latitude,
                                longitude: location.longitude
                            )
                        )
                        .accessibilityHint(Localized.accessibilityOpenInWikipediaHint)
                    }
                } footer: {
                    if let error = viewModel.onOpenError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                    } else {
                        Text(Localized.tapLocation)
                    }
                }
            }
            .refreshable {
                viewModel.loadLocations()
            }
            .navigationTitle(Localized.places)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCustomLocation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(Localized.accessibilityAddCustomLocation)
                }
            }
            .overlay {
                if viewModel.loadState == .loading {
                    ProgressView()
                        .accessibilityLabel(Localized.accessibilityLoadingPlaces)
                }
            }
        }
        .task {
            viewModel.loadLocations()
        }
        .onChange(of: viewModel.onOpenError) { _, error in
            guard let error else { return }
            AccessibilityNotification.Announcement(error).post()
        }
        .sheet(isPresented: $showingCustomLocation) {
            NavigationStack {
                CustomLocationView(
                    viewModel: CustomLocationViewModel()
                )
            }
        }
        .onAppear {
            customLocationViewModel.onAdd = { location in
                viewModel.addLocation(location)
                showingCustomLocation = false
            }
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
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
