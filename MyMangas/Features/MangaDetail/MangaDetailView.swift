import SwiftUI

struct MangaDetailView: View {
    @Environment(MangasListViewModel.self) private var vm
    @Binding var selected: Manga?
    @State private var loaded = false
    private var manga: Manga!
    
    init(selected: Binding<Manga?>) {
        _selected = selected
        if let manga = selected.wrappedValue {
            self.manga = manga
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack {
                    MangaCoverView(manga: manga, detailViewMode: true)
                    Text(manga.title ?? "")
                        .font(.title)
                        .bold()
                    if let authors = manga.authors {
                        VStack {
                            Text("Authors")
                                .bold()
                            ForEach(authors) {
                                Text("\($0.firstName) \($0.lastName)")
                            }
                        }
                        .padding()
                    }
                    if let synopsis = manga.sypnosis {
                        Text(synopsis)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            Button {
                selected = nil
            } label: {
                Image(systemName: "xmark")
                    .symbolVariant(.circle)
                    .symbolVariant(.fill)
                    .font(.largeTitle)
            }
            .padding(.trailing)
            .buttonStyle(.plain)
            .opacity(0.5)
            .offset(x: !loaded ? 100 : selected != nil ? 0 : 100)
        }
        .animation(.default, value: loaded)
        .onAppear {
            loaded = true
        }
    }
}

#Preview {
    MangaDetailView(selected: .constant(.preview))
        .environment(MangasListViewModel.preview)
}
