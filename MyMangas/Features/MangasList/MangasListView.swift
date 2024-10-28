import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var selected: MangasListItemViewModel?
    @State var onlyFavorites = false
    @State var searchText = ""
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    if vm.returnMangas(onlyFavorites).isEmpty {
                        Text("\n\nNo favorites mangas yet\n")
                            .font(.headline)
                        Text("Add favorites by continous tapping in list or detail")
                    } else {
                        LazyVGrid(columns: [gridItem]) {
                            ForEach(searchResults) { manga in
                                MangasListCellView(manga: manga)
                                .onTapGesture {
                                    selected = manga
                                }
                                .contextMenu {
                                    Button {
                                        vm.toogleFavorite(manga)
                                    } label: {
                                        Label(manga.isFavorite ? "Remove favorite" : "Add favorite",
                                              systemImage: manga.isFavorite ? "heart.slash": "heart")
                                    }
                                }
                                .task {
                                    if vm.shouldLoadMore(manga: manga) && !onlyFavorites {
                                        await vm.getMangas()
                                    }
                                }
                            }
                        }
                        .addCustomSearchBar(searchText: $searchText,
                                            placeholder: "Search manga...",
                                            visible: selected == nil)
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
        .animation(.smooth(duration: 0.15), value: selected)
    }
    
    var searchResults: [MangasListItemViewModel] {
        if searchText.isEmpty {
            return vm.returnMangas(onlyFavorites)
        } else {
            return vm.returnMangas(onlyFavorites).filter {
                $0.title.contains(searchText) || $0.synopsis.contains(searchText)
            }
        }
    }

}

#Preview {
    MangasListView.preview
}
