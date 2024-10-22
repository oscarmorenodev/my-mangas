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
                            .addFavouriteButton(manga: manga,
                                                size: CGSize(width: 40, height: 40),
                                                offset: (x: 70, y: 90))
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
