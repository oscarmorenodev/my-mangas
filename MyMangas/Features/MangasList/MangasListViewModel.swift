import Foundation

@Observable
final class MangasListViewModel {
    let interactor: DataInteractor
    var mangas = [MangasListItemViewModel]()
    var displayError = false
    var errorMessage = ""
    var appState: AppState = .splash
    
    init(interactor: DataInteractor = DataService()) {
        self.interactor = interactor
    }
    
    func getMangas() async -> [MangasListItemViewModel] {
        do {
            let mangas = try await interactor.getMangas().items
            await MainActor.run {
                self.mangas = mangas.map {MangasListItemViewModel(manga: $0, isFavorite: false)}
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError.toggle()
            }
        }
        
        return mangas
    }
    
    func returnMangas(_ onlyFavorites: Bool = false) -> [MangasListItemViewModel] {
        onlyFavorites ? mangas.filter {$0.isFavorite} : mangas
    }
    
    func toogleFavorite(_ manga: MangasListItemViewModel) {
        if let index = mangas.firstIndex(where: { $0.title == manga.title}) {
            mangas[index].isFavorite.toggle()
        }
    }
}
