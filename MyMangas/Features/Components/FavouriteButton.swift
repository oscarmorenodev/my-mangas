import SwiftUI

fileprivate struct FavouriteButton: ViewModifier {
    @Environment(MangasListViewModel.self) private var vm
    @State var manga: MangasListItemViewModel
    @State var size: CGSize
    @State var offset: (x: CGFloat, y: CGFloat)
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Button {
                    vm.toogleFavourite(manga)
                    manga.isFavourite.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: size.width,
                                   height: size.height)
                            .tint(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        Image(systemName: manga.isFavourite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: size.width/2,
                                   height: size.height/2)
                            .tint(.red)
                    }
                }
                .offset(x: offset.x, y: offset.y)
            }
    }
}

extension View {
    func addFavouriteButton(manga: MangasListItemViewModel,
                            size: CGSize,
                            offset: (x: CGFloat, y: CGFloat)) -> some View {
        modifier(FavouriteButton(manga: manga,
                                 size: size,
                                 offset: (x: offset.x, y: offset.y)))
    }
}
