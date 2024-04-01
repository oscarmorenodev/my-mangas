import SwiftUI

struct MangasListCellView: View {
    @State private var cellVM = MangasListCellViewModel()
    let manga: Manga
    let namespace: Namespace.ID
    var coverFullView = false
    
    var body: some View {
        VStack {
            if let cover = cellVM.image {
                Image(uiImage: cover)
                    .resizable()
                    .matchedGeometryEffect(id: "cover\(manga.id)", in: namespace)
                    .scaledToFill()
                    .frame(width: coverFullView ? 250 : 150,
                           height: coverFullView ? 420 : 230)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    .frame(height: coverFullView ? 420 : 250)
            } else {
                MangaListCellPlaceholderView(manga: manga,
                                             namespace: namespace)
            }
            if !coverFullView {
                Text(manga.title ?? "")
                    .font(.callout)
                    .bold()
                    .lineLimit(1)
            }
        }
        .onAppear {
            try? cellVM.getImage(url: manga.mainPicture ?? "")
        }
    }
}

#Preview {
    MangasListCellView(manga: .preview, namespace: Namespace().wrappedValue)
}
