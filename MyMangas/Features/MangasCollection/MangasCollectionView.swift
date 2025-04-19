import SwiftUI

struct MangasCollectionView: View {
    @Environment(MangasCollectionViewModel.self) var vm
    @State var selected: MangaItemViewModel?
    @State var loading = false
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        ZStack {
            NavigationStack {
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
        .task {
            await vm.getMangas()
        }
    }
}

#Preview {
    MangasCollectionView.preview
}
