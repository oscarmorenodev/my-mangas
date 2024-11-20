import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var selected: MangaItemViewModel?
    @State var searchText = ""
    @State var showFilters = false
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await vm.toggleBestMangas()
                        }
                    } label: {
                        HStack{
                            Text(vm.showBest ? "No order" : "Order by best")
                            Image(systemName: vm.showBest ? "line.3.horizontal" : "star.fill")
                        }
                    }
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                ScrollView {
                    LazyVGrid(columns: [gridItem]) {
                        ForEach(vm.mangas) { manga in
                            MangaItemView(manga: manga)
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
                                    if vm.shouldLoadMore(manga: manga) {
                                        await vm.getMangas()
                                    }
                                }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        
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
        .animation(.smooth(duration: 0.15), value: selected)
    }
}

#Preview {
    MangasListView.preview
}
