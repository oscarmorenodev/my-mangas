import SwiftUI

struct MangaCoverView: View {
    let manga: Manga
    var detailViewMode: Bool = false
    
    var body: some View {
        AsyncImage(url: manga.mainPicture?.formatedToUrl()) { cover in
            MangaMainCoverView(cover: cover, 
                               detailViewMode: detailViewMode)
        } placeholder: {
            MangaPlaceholderCoverView(detailViewMode: detailViewMode)
        }

    }
}

#Preview {
    MangaCoverView(manga: .preview)
}
