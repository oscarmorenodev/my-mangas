import Foundation

@Observable
final class MangasCollectionViewModel {
    private let getMangaCollectionUseCase: GetMangaCollectionUseCase
    var mangas = [MangaCollectionItemViewModel]()
    var displayError = false
    var errorMessage = ""
    
    init(getMangaCollectionUseCase: GetMangaCollectionUseCase = GetMangaCollectionUseCase()) {
        self.getMangaCollectionUseCase = getMangaCollectionUseCase
    }
    
    func loadCollection() async {
        do {
            let collection = try await getMangaCollectionUseCase.getCollection()
            await MainActor.run {
                self.mangas = collection.map{ MangaCollectionItemViewModel(manga: $0.manga, completeCollection: $0.completeCollection, volumesOwned: $0.volumesOwned, readingVolume: $0.readingVolume)}
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func handleError(_ error: any Error) async {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.displayError = true
        }
    }
}
