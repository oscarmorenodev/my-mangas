import SwiftUI

struct MainView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var searchVM = MangasSearchViewModel()
    
    var body: some View {
        TabView {
            MangasListView()
                .tabItem {
                    Label("Explore",
                          systemImage: "book.fill")
                }
            MangasSearchView(vm:searchVM)
                .tabItem {
                    Label("Search",
                            systemImage: "magnifyingglass")
                }
            MangasFavoritesView()
                .tabItem {
                    Label("My Library",
                          systemImage: "books.vertical")
                }
        }
    }
}

#Preview {
    MainView.preview
}
