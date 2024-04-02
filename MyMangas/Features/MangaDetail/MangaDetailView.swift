import SwiftUI

struct MangaDetailView: View {
    @Environment(MangasListViewModel.self) private var vm
    @Binding var selected: Manga?
    @Binding var userInteraction: Bool
    @State private var loaded = false
    let namespace: Namespace.ID
    private var manga: Manga!
    
    init(selected: Binding<Manga?>, userInteraction: Binding<Bool>, namespace: Namespace.ID) {
        _selected = selected
        _userInteraction = userInteraction
        self.namespace = namespace
        if let manga = selected.wrappedValue {
            self.manga = manga
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack {
                    MangasListCellView(manga: manga, namespace: namespace, coverFullView: true)
                    Text(manga.titleEnglish ?? "")
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
                userInteraction = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    userInteraction = true
                }
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
    MangaDetailView(selected: .constant(.preview), userInteraction: .constant(false), namespace: Namespace().wrappedValue)
        .environment(MangasListViewModel.preview)
}
