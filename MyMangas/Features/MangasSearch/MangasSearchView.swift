import SwiftUI

struct MangasSearchView: View {
    @Bindable var vm: MangasSearchViewModel
    
    var body: some View {
        NavigationView {
            Text("Search results for \(vm.searchText)")
        }
        .addCustomSearchBar(searchText: $vm.searchText, placeholder: "Search for a manga")
    }
}

#Preview {
    MangasSearchView(vm: .preview)
}
