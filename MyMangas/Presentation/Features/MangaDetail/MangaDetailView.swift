import SwiftUI

struct MangaDetailView<T: MangaItem>: View {
    @State private var viewModel = MangaDetailViewModel()
    @Binding var selected: T?
    @State private var loaded = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack {
                    if let manga = selected {
                        MangaItemView(detailViewMode: true,
                                      manga: manga)
                        .addToCollectionButton(manga: manga,
                                               size: CGSize(width: 70,
                                                            height: 70),
                                               offset: (x: 130,
                                                        y: 180))
                        .padding(.top, UIDevice.current.userInterfaceIdiom != .phone ? 100 : 0)
                        Text(manga.title)
                            .font(.title)
                            .bold()
                        VStack {
                            Text("Authors")
                                .bold()
                            ForEach(manga.authors, id: \.self) {
                                Text($0)
                            }
                        }
                        .padding()
                        Text(manga.synopsis)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            Button {
                selected = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
            }
            .padding(.trailing)
            .buttonStyle(.plain)
            .foregroundStyle(Color.primary.opacity(0.5))
            .offset(x: !loaded ? 100 : selected != nil ? 0 : 100,
                    y: UIDevice.current.userInterfaceIdiom != .phone ? 20 : 0)
        }
        .animation(.smooth(duration: 0.15), value: loaded)
        .onAppear {
            loaded = true
            if let manga = selected {
                viewModel.loadMangaDetail(mangaId: manga.id)
            }
        }
    }
}

#Preview {
    MangaDetailView(selected: .constant(MangaItemViewModel.preview))
        .environment(MangasListViewModel.preview)
}
