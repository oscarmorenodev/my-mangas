import SwiftUI

struct MangasCollectionView: View {
    @Environment(MangasCollectionViewModel.self) var vm
    @State private var selected: MangaCollectionItemViewModel?
    @State private var loading = false
    
    private let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        ZStack {
            mainContent
                .animation(.smooth(duration: 0.15), value: selected)
            detailOverlay
        }
        .task {
            await vm.loadCollection()
        }
    }
    
    private var mainContent: some View {
        NavigationStack {
            ZStack {
                mangaGrid
                loadingIndicator
            }
        }
        .opacity(selected == nil ? 1.0 : 0.0)
    }
    
    private var mangaGrid: some View {
        ScrollView {
            LazyVGrid(columns: [gridItem]) {
                ForEach(vm.mangas) { manga in
                    MangaItemView(manga: manga)
                        .onTapGesture {
                            selected = manga
                        }
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        LoadingView(loading: $loading)
            .offset(y: 200)
            .opacity(loading ? 1 : 0)
    }
    
    private var detailOverlay: some View {
        Group {
            if let selected {
                MangaDetailView(selected: .constant(selected))
            }
        }
    }
}

#Preview {
    MangasCollectionView.preview
}
