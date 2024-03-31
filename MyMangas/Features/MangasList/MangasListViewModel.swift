import Foundation

@Observable
final class MangasListViewModel {
    let interactor: DataInteractor
    var mangas = [Manga]()
    var displayError = false
    var errorMessage = ""
    
    init(interactor: DataInteractor = Network()) {
        self.interactor = interactor
    }
    
    func getMangas() async -> [Manga] {
        do {
            let mangas = try await interactor.getMangas().items
            await MainActor.run {
                self.mangas = mangas
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError.toggle()
            }
        }
        
        return mangas
    }
}
