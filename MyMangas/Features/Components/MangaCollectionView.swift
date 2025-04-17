import SwiftUI
import MyMangasCore

struct MangaCollectionView: View {
    let viewModel: MangaCollectionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: viewModel.mainPicture)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(viewModel.authors.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(viewModel.volumes) volúmenes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(viewModel.collection)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }
}

#Preview {
    MangaCollectionView(
        viewModel: MangaCollectionViewModel(
            id: 1,
            title: "One Piece",
            authors: ["Eiichiro Oda"],
            synopsis: "La historia de Monkey D. Luffy",
            mainPicture: "https://example.com/onepiece.jpg",
            volumes: 100,
            isFavorite: true,
            collection: "Colección 1"
        )
    )
} 