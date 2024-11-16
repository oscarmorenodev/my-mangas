import SwiftUI

struct MangasSearchView: View {
    @Bindable var vm: MangasSearchViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.searchResults) { manga in
                    MangaItemView(manga: manga)
                }
            }
        }
        .addCustomSearchBar(searchText: $vm.searchText, placeholder: "Search for a manga")
        .onChange(of: vm.searchText) {
            if vm.searchText.isEmpty {
                vm.searchResults.removeAll()
            } else {
                Task {
                    await vm.searchMangas()
                }
            }
        }
    }
}

#Preview {
    MangasSearchView(vm: .preview)
}
