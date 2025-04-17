import Foundation

@MainActor
final class MangaAddToCollectionFormViewModel: ObservableObject {
    @Published var completeCollection = false {
        didSet {
            if completeCollection {
                volumesOwned = Array(1...numberOfVolumes)
            }
        }
    }
    @Published var volumesOwned: [Int] = []
    @Published var readingVolume: Int?
    @Published var error: String?
    
    let mangaId: Int
    let numberOfVolumes: Int
    let interactor: DataInteractor
    
    init(mangaId: Int, numberOfVolumes: Int, interactor: DataInteractor = DataService()) {
        self.mangaId = mangaId
        self.numberOfVolumes = numberOfVolumes
        self.interactor = interactor
    }
    
    func addToCollection() async {
        let request = UserMangaCollectionRequest(
            manga: mangaId,
            completeCollection: completeCollection,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume
        )
        
        do {
            try await interactor.addOrUpdateMangaCollection(request)
        } catch {
            self.error = error.localizedDescription
        }
    }
} 
