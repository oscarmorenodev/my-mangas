import Foundation

@Observable
final class MangasCollectionViewModel {
    var mangas = [MangaCollectionItemViewModel]()
    var displayError = false
    var errorMessage = ""
    
    private let interactor: DataInteractor
    
    init(interactor: DataInteractor = DataService.shared) {
        self.interactor = interactor
    }
    
    func loadCollection() async {
        do {
            let collection = try await interactor.getCollection()
            await MainActor.run {
                self.mangas = collection.map{ MangaCollectionItemViewModel(manga: $0.manga, completeCollection: $0.completeCollection, volumesOwned: $0.volumesOwned, readingVolume: $0.readingVolume)}
            }
        } catch {
            await handleError(error)
        }
    }
    
    func addOrUpdateManga(_ manga: UserMangaCollectionRequest) async {
        do {
            try await interactor.addOrUpdateMangaCollection(manga)
            await loadCollection()
        } catch {
            await handleError(error)
        }
    }
    
    func deleteManga(id: Int) async {
        do {
            try await interactor.deleteMangaFromCollection(id: id)
            await loadCollection()
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
