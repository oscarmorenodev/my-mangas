import SwiftUI

fileprivate struct AddToCollectionButton: ViewModifier {
    @Environment(MangasListViewModel.self) private var vm
    let manga: MangaItemViewModel
    @State private var showCollectionForm = false
    let size: CGSize
    let offset: (x: CGFloat, y: CGFloat)
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Button {
                    showCollectionForm = true
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: size.width,
                                   height: size.height)
                            .tint(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        Image(systemName: "books.vertical.circle.fill")
                            .resizable()
                            .frame(width: size.width,
                                   height: size.height)
                            .tint(.blue)
                    }
                }
                .offset(x: offset.x, y: offset.y)
            }
            .sheet(isPresented: $showCollectionForm) {
                MangaAddToCollectionFormView(mangaId: manga.id, numberOfVolumes: manga.volumes)
            }
    }
}

extension View {
    func addToCollectionButton(manga: MangaItemViewModel,
                           size: CGSize,
                           offset: (x: CGFloat, y: CGFloat)) -> some View {
        modifier(AddToCollectionButton(manga: manga,
                                size: size,
                                offset: (x: offset.x, y: offset.y)))
    }
}
