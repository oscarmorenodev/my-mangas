import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var selected: MangasListItemViewModel?
    @Namespace var namespace
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        ZStack {
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
                .opacity(selected == nil ? 1.0 : 0.0)
                .overlay(
                    Group {
                        if selected != nil {
                            MangaDetailView(selected: $selected, namespace: namespace)
                        }
                    }
                )
            }
        }
        .animation(.smooth(duration: 0.15), value: selected)
    }
    
}

#Preview {
    MangasListView.preview
}
