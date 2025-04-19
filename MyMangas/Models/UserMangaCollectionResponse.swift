struct UserMangaCollectionResponse: Decodable {
    var manga: Manga
    var completeCollection: Bool
    var volumesOwned: [Int]
    var readingVolume: Int?
}
