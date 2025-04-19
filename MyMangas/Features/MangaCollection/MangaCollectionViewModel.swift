import Foundation

struct MangaCollectionViewModel {
    let mangaId: Int
    let hasCompleteCollection: Bool
    let volumesOwned: [Int]
    let currentReadingVolume: Int?
    
    init(request: UserMangaCollectionRequest) {
        mangaId = request.manga
        hasCompleteCollection = request.completeCollection
        volumesOwned = request.volumesOwned
        currentReadingVolume = request.readingVolume
    }
    
    func toRequest() -> UserMangaCollectionRequest {
        UserMangaCollectionRequest(
            manga: mangaId,
            completeCollection: hasCompleteCollection,
            volumesOwned: volumesOwned,
            readingVolume: currentReadingVolume
        )
    }
}

extension MangaCollectionViewModel {
    static let preview = MangaCollectionViewModel(
        request: UserMangaCollectionRequest(
            manga: 42,
            completeCollection: true,
            volumesOwned: [1, 2, 3],
            readingVolume: 3
        )
    )
    
    func toMangaItemViewModel() -> MangaItemViewModel {
        MangaItemViewModel(
            id: mangaId,
            title: "",
            authors: [],
            synopsis: "",
            mainPicture: "",
            volumes: volumesOwned.count,
            isFavorite: true
        )
    }
} 