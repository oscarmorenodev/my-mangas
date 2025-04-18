import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var selected: MangaItemViewModel?
    @State var searchText = ""
    @State var showFilters = false
    @State var showSheet: Bool = false
    @State var selectedCategory = ""
    @State var loading = false
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                if showFilters {
                    VStack {
                        MangasCategoriesView(selectedCategory: $selectedCategory, loading: $loading)
                            .environment(vm)
                    }
                }
                if loading {
                    LoadingView(loading: $loading)
                        .offset(y: 200)
                }
                ScrollView {
                    LazyVGrid(columns: [gridItem]) {
                        ForEach(vm.mangas) { manga in
                            MangaItemView(manga: manga)
                                .onTapGesture {
                                    selected = manga
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
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Filters", systemImage: "line.3.horizontal.decrease.circle") {
                            showFilters.toggle()
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
        .animation(.smooth(duration: 0.15), value: selected)
    }
}

#Preview {
    MangasListView.preview
}
