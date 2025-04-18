import Foundation

@Observable
final class MangasCollectionViewModel {
    var mangas = [UserMangaCollectionRequest]()
    var displayError = false
    var errorMessage = ""
    
    private let dataService: DataInteractor
    
    init(dataService: DataInteractor = DataService.shared) {
        self.dataService = dataService
    }
    
    func loadCollection() async {
        do {
            let collection = try await dataService.getCollection()
            await MainActor.run {
                self.mangas = collection
            }
        } catch {
            await handleError(error)
        }
    }
    
    func addOrUpdateManga(_ manga: UserMangaCollectionRequest) async {
        do {
            try await dataService.addOrUpdateMangaCollection(manga)
            await loadCollection()
        } catch {
            await handleError(error)
        }
    }
    
    func deleteManga(id: Int) async {
        do {
            try await dataService.deleteMangaFromCollection(id: id)
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
