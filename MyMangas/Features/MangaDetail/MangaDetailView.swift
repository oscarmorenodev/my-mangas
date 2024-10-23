import SwiftUI

struct MangaDetailView: View {
    @Environment(MangasListViewModel.self) private var vm
    @Binding var selected: MangasListItemViewModel?
    @State private var loaded = false
    private var namespace: Namespace.ID
    private var manga: MangasListItemViewModel!
    
    init(selected: Binding<MangasListItemViewModel?>, namespace: Namespace.ID) {
        _selected = selected
        self.namespace = namespace
        if let manga = selected.wrappedValue {
            self.manga = manga
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack {
                    AsyncImage(url: manga.mainPicture.formatedToUrl()) { cover in
                        cover
                            .resizable()
                            .scaledToFill()
                            .matchedGeometryEffect(id: manga.id, in: namespace)
                            .frame(width: 250, height: 420)                .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .frame(height: 420)
                    } placeholder: {
                        Image(systemName: SystemImage.placeholder.rawValue)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 150, height: 230)                .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(Color.white.opacity(0.8))
                            .background {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.5))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .frame(height: 250)
                    }
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
            .offset(x: !loaded ? 100 : selected != nil ? 0 : 100)
        }
        .animation(.default, value: loaded)
        .onAppear {
            loaded = true
        }
    }
}

#Preview {
    MangaDetailView(selected: .constant(.preview),
                    namespace: Namespace().wrappedValue)
    .environment(MangasListViewModel.preview)
}
