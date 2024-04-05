import SwiftUI

struct MangasListCellView: View {
    let manga: Manga
    
    var body: some View {
        VStack {
            MangaCoverView(manga: manga)
            Text(manga.title ?? "")
                .font(.caption)
                .bold()
                .lineLimit(1)
        }
    }
}

#Preview {
    MangasListCellView(manga: .preview)
}
