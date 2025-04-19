struct MangaCollectionItemViewModel: Identifiable, Hashable, MangaItem {
    let id: Int
    let title: String
    let authors: [String]
    let synopsis: String
    let mainPicture: String
    let volumes: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
    
    init(manga: Manga, completeCollection: Bool, volumesOwned: [Int], readingVolume: Int?) {
        id = manga.id
        title = manga.title ?? ""
        authors = manga.authors?.map { "\($0.firstName) \($0.lastName)" } ?? []
        synopsis = manga.sypnosis ?? ""
        mainPicture = manga.mainPicture ?? ""
        volumes = manga.volumes ?? 1
        self.completeCollection = completeCollection
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
    }
    
    static func == (lhs: MangaCollectionItemViewModel, rhs: MangaCollectionItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

