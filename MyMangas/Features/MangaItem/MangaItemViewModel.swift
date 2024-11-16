struct MangaItemViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let authors: [String]
    let synopsis: String
    let mainPicture: String
    var isFavorite: Bool
    
    init(manga: Manga, isFavorite: Bool = false) {
        id = manga.id
        title = manga.title ?? ""
        authors = manga.authors?.map { "\($0.firstName) \($0.lastName)" } ?? []
        synopsis = manga.sypnosis ?? ""
        mainPicture = manga.mainPicture ?? ""
        self.isFavorite = isFavorite
    }
}
