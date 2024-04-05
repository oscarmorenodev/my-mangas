import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var selected: Manga?
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [gridItem]) {
                            ForEach(vm.mangas) { manga in
                                MangasListCellView(manga: manga)
                                .onTapGesture {
                                    selected = manga
                                }
                            }
                        }
                    }
                }
                .opacity(selected == nil ? 1.0 : 0.0)
            if selected != nil {
                MangaDetailView(selected: $selected)
            }
        }
        .animation(.spring, value: selected)
    }
    
}

#Preview {
    MangasListView.preview
}
