import SwiftUI

struct MangaMainCoverView: View {
    let cover: Image
    let namespace: Namespace.ID
    let mangaId: Int
    var detailViewMode: Bool = false
    
    var body: some View {
        VStack {
            cover
                .resizable()
                .matchedGeometryEffect(id: mangaId, in: namespace)
                .scaledToFill()
                .frame(width: detailViewMode ? 250 : 150,
                       height: detailViewMode ? 420 : 230)                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                .frame(height: detailViewMode ? 420 : 250)
        }
    }
}

#Preview {
    MangaMainCoverView(cover: Image("DragonBallCover"), 
                       namespace: Namespace().wrappedValue, 
                       mangaId: 1)
}
