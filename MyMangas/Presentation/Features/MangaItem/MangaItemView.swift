import SwiftUI

struct MangaItemView: View {
    @State var detailViewMode: Bool = false
    var manga: MangaItem
    
    var body: some View {
        VStack {
            AsyncImage(url: manga.mainPicture.formatedToUrl()) { cover in
                cover
                    .resizable()
                    .scaledToFill()
                    .frame(width: detailViewMode ? 250 : 150,
                           height: detailViewMode ? 420 : 230)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
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
            }
            Text(manga.title)
                .font(.callout)
                .bold()
                .lineLimit(1)
        }
    }
}

#Preview {
    MangaItemView.preview
}
