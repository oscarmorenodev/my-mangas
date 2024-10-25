import SwiftUI

struct MangaCoverView: View {
    let manga: MangasListItemViewModel
    let namespace: Namespace.ID
    var detailViewMode: Bool = false
    
    var body: some View {
        AsyncImage(url: manga.mainPicture.formatedToUrl()) { cover in
            cover
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 230)                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                .frame(height: 250)
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
    }
}

#Preview {
    MangaCoverView(manga: .preview, namespace: Namespace().wrappedValue)
}
