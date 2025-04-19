import SwiftUI

struct MangasSearchView: View {
    @Bindable var vm: MangasSearchViewModel
    @State var selected: MangaItemViewModel?
    @State var loading = false
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        NavigationStack {
            if loading {
                LoadingView(loading: $loading)
            } else {
                ScrollView {
                    LazyVGrid(columns: [gridItem]) {
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
                    loading = true
                    await vm.searchMangas()
                    loading = false
                }
            }
        }
    }
}

#Preview {
    MangasSearchView(vm: .preview)
}
