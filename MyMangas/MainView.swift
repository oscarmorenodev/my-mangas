import SwiftUI

struct MainView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        TabView {
            MangasListView()
                .tabItem {
                    Label("Explore",
                          systemImage: "book.fill")
                }
            MangasSearchView()
                .tabItem {
                    Label("Search",
                            systemImage: "magnifyingglass")
                }
            MangasListView(onlyFavorites: true)
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
