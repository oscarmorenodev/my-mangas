import SwiftUI

struct MangaPlaceholderCoverView: View {
    let namespace: Namespace.ID
    let mangaId: Int
    var detailViewMode: Bool = false

    var body: some View {
        Image(systemName: SystemImage.placeholder.rawValue)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: detailViewMode ? 250 : 150,
                   height: detailViewMode ? 420 : 230)                .clipShape(RoundedRectangle(cornerRadius: 10))
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
    MangaPlaceholderCoverView(namespace: Namespace().wrappedValue, mangaId: 1)
}
