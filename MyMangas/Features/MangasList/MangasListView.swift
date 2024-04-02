import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @Namespace private var namespace
    @State var selected: Manga?
    @State var userInteraction = true
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
            if selected == nil {
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [gridItem]) {
                            ForEach(vm.mangas) { manga in
                                MangasListCellView(manga: manga,
                                                   namespace: namespace)
                                .onTapGesture {
                                    selected = manga
                                }
                            }
                        }
                    }
                }
                .opacity(selected == nil ? 1.0 : 0.0)
            } else {
                MangaDetailView(selected: $selected, userInteraction: $userInteraction, namespace: namespace)
            }
            if !userInteraction {
                Color.white.opacity(0.01).ignoresSafeArea()
            }
        }
        .animation(.linear(duration: 0.4), value: selected)
    }
    
}

#Preview {
    MangasListView.preview
}
