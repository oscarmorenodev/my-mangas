import SwiftUI

struct MangasSearchView: View {
    @Bindable var vm: MangasSearchViewModel
    @State var selected: MangaItemViewModel?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.searchResults, id: \.id) { manga in
                        MangaItemView(manga: manga)
                            .onTapGesture {
                                selected = manga
                            }
                            .task {
                                if vm.shouldLoadMore(manga: manga) {
                                    await vm.loadMoreMangas()
                                }
                            }
                    }
                }
                
            }
            .opacity(selected == nil ? 1.0 : 0.0)
            .overlay(
                Group {
                    if selected != nil {
                        MangaDetailView(selected: $selected)
                    }
                }
            )
        }
        .addCustomSearchBar(
            searchText: $vm.searchText,
            placeholder: "Search for a manga"
        )
        .onChange(of: vm.searchText) {
            if vm.searchText.isEmpty {
                vm.cleanSearchResults()
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
