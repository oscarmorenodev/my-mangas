import SwiftUI

struct MainView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        TabView {
            MangasListView()
                .tabItem {
                    Label("Explore",
                          systemImage: "magnifyingglass")
                }
            MyLibraryView()
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
