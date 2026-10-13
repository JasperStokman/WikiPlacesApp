import SwiftUI
import Playgrounds

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsViewModel
    
    
    init(viewModel: LocationsViewModel) {
       
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
