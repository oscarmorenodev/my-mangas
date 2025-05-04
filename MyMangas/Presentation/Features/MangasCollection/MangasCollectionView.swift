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
        .refreshable {
            await vm.loadCollection()
        }
    }
    
    private var mainContent: some View {
        NavigationStack {
            ZStack {
                if !loading && vm.mangas.isEmpty {
                    emptyCollectionView
                } else {
                    mangaGrid
                }
                loadingIndicator
            }
            .padding(UIDevice.current.userInterfaceIdiom != .phone ? 20 : 0)
        }
        .opacity(selected == nil ? 1.0 : 0.0)
    }
    
    private var emptyCollectionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 70))
                .foregroundStyle(.secondary)
            
            Text("No mangas in your collection")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Add mangas to your collection to see them here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            .padding(.top, 10)
        }
        .padding()
        .multilineTextAlignment(.center)
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
            if selected != nil {
                MangaDetailView(selected: $selected)
            }
        }
    }
}

#Preview {
    MangasCollectionView.preview
}
