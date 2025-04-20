import Foundation

@Observable
final class MangaAddToCollectionFormViewModel {
    var completeCollection = false {
        didSet {
            if completeCollection {
                volumesOwned = Array(1...numberOfVolumes)
            }
        }
    }
    var volumesOwned: [Int] = []
    var readingVolume: Int?
    var error: String?
    
    let mangaId: Int
    let numberOfVolumes: Int
    private let getMangaCollectionUseCase: GetMangaCollectionUseCase
    
    init(mangaId: Int,
         numberOfVolumes: Int,
         getMangaCollectionUseCase: GetMangaCollectionUseCase = GetMangaCollectionUseCase()) {
        self.mangaId = mangaId
        self.numberOfVolumes = numberOfVolumes
        self.getMangaCollectionUseCase = getMangaCollectionUseCase
    }
    
    func addToCollection() async {
        let request = UserMangaCollectionRequest(
            manga: mangaId,
            completeCollection: completeCollection,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume
        )
        
        do {
            try await getMangaCollectionUseCase.addOrUpdateMangaCollection(request)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func removeOfCollection(id: Int) async {
        do {
            try await getMangaCollectionUseCase.deleteMangaFromCollection(id: id)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
