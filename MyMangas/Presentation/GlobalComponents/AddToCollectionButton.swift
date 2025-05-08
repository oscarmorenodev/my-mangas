import SwiftUI

fileprivate struct AddToCollectionButton: ViewModifier {
    @Environment(MangasListViewModel.self) private var mangaListVM
    let manga: MangaItem
    @State private var showCollectionForm = false
    let size: CGSize
    let offset: (x: CGFloat, y: CGFloat)
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Button {
                    showCollectionForm = true
                } label: {
                    Image(systemName: "books.vertical.circle.fill")
                        .resizable()
                        .frame(width: size.width,
                               height: size.height)
                        #if os(visionOS)
                        .foregroundStyle(.white)
                        .background(.blue)
                        #else
                        .tint(.blue)
                        .background(.white)
                        #endif
                        .clipShape(Circle())
                }
                .offset(x: offset.x, y: offset.y)
            }
            .sheet(isPresented: $showCollectionForm) {
                MangaAddToCollectionFormView(vm: MangaAddToCollectionFormViewModel(mangaId: manga.id,
                                                                                   numberOfVolumes: manga.volumes))
            }
    }
}

extension View {
    func addToCollectionButton(manga: MangaItem) -> some View {
        modifier(AddToCollectionButton(manga: manga,
                                       size: CGSize(width: 70,
                                                    height: 70),
                                       offset: (x: 130,
                                                y: 180)))
    }
}
