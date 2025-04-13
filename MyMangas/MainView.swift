import SwiftUI

struct MainView: View {
    @Environment(MangasListViewModel.self) var vm
    @Environment(AppStateManager.self) var appStateManager
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
            UserView()
                .tabItem {
                    Label("User",
                          systemImage: "person.fill")
                }
        }
        .onAppear {
            Task {
                await appStateManager.checkTokenStatus()
            }
        }
    }
}

#Preview {
    MainView.preview
}
