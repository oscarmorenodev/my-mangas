protocol MangaItem {
    var id: Int { get }
    var title: String { get }
    var authors: [String] { get }
    var synopsis: String { get }
    var mainPicture: String { get }
    var volumes: Int { get }
}

struct MangaItemViewModel: Identifiable, Hashable, MangaItem {
    let id: Int
    let title: String
    let authors: [String]
    let synopsis: String
    let mainPicture: String
    let volumes: Int
    var inCollection: Bool
    
    init(manga: Manga, inCollection: Bool = false) {
        id = manga.id
        title = manga.title ?? ""
        authors = manga.authors?.map { "\($0.firstName) \($0.lastName)" } ?? []
        synopsis = manga.sypnosis ?? ""
        mainPicture = manga.mainPicture ?? ""
        volumes = manga.volumes ?? 1
        self.inCollection = inCollection
    }
    
    static func == (lhs: MangaItemViewModel, rhs: MangaItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
