import SwiftUI

struct MangaListCellPlaceholderView: View {
    let manga: Manga
    let namespace: Namespace.ID
    
    var body: some View {
        Image(systemName: SystemImage.placeholder.rawValue)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: 150, height: 230)
            .foregroundStyle(Color.white.opacity(0.8))
            .background {
                Rectangle()
                    .fill(Color.blue.opacity(0.5))
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            .frame(height: 250)
    }
}

#Preview {
    MangaListCellPlaceholderView(manga: .preview,
                                 namespace: Namespace().wrappedValue)
}
