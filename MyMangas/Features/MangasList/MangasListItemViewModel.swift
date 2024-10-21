struct MangasListItemViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let authors: [String]
    let synopsis: String
    let mainPicture: String
    let isFavourite: Bool
    
    init(manga: Manga) {
        id = manga.id
        title = manga.title ?? ""
        authors = manga.authors?.map { "\($0.firstName) \($0.lastName)" } ?? []
        synopsis = manga.sypnosis ?? ""
        mainPicture = manga.mainPicture ?? ""
        isFavourite = false
    }
}
